import 'package:decodart/model/image.dart';
import 'package:flutter/material.dart' show Colors, LayoutBuilder;
import 'package:flutter/cupertino.dart';

class ImagePainter extends CustomPainter {
  final List<Offset> points;
  final bool isIn;
  final bool isDrawing;

  ImagePainter(this.points, this.isIn, this.isDrawing);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDrawing
        ?Colors.blue.withOpacity(0.2)
        :isIn
          ?Colors.green.withOpacity(0.2)
          :Colors.red.withOpacity(0.2)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0;
    if (points.length > 1) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    } else if (points.isNotEmpty){
      canvas.drawCircle(points[0], 15, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ImageDrawingWidget extends StatefulWidget {
  final AbstractImage image;
  final void Function(int) foundCorrect;
  final void Function() foundIncorrect;
  final bool isOver;
  final bool isCorrect;
  

  const ImageDrawingWidget({
    super.key,
    required this.image,
    required this.foundCorrect,
    required this.foundIncorrect,
    required this.isOver,
    required this.isCorrect,
  });

  @override
  State<ImageDrawingWidget> createState() => _ImageDrawingWidgetState();
}

class _ImageDrawingWidgetState extends State<ImageDrawingWidget> {
  final TransformationController _transformationController = TransformationController();
  late double _width;
  late double _height;
  bool scaling = false;
  
  bool isDrawing = false;
  List<List<Offset>> points = [];
  List<bool> isCorrect = [];
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();
  late Offset offset;
  Offset _startFocalPoint = Offset.zero;
  
  Matrix4 lastTransformation = Matrix4.identity();
  late Matrix4 currentTransformation;

  final double _zoomMax = 4, _zoomMin = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setOffsetAndDimension();
      setState(() {});
    });
  }
  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _setOffsetAndDimension() {
    final renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    final containerBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && containerBox != null) {
      _width = renderBox.size.width;
      _height = renderBox.size.height;
      final imagePosition = renderBox.localToGlobal(Offset.zero);
      final containerPosition = containerBox.localToGlobal(Offset.zero);
      offset = imagePosition - containerPosition;
    }
  }

  @override
  void didUpdateWidget(covariant ImageDrawingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      points.clear();
      isCorrect.clear();
      lastTransformation = Matrix4.identity();
      _transformationController.value = Matrix4.identity();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  void _isLastIn() {
    // calls the callbacks with respect to the last drawing done
    bool isIn = false;
    int i = 0;
    while (i < (widget.image.boundingBoxes?.length??0) && !isIn) {
      int nbCorrect = 0;
      final bb = widget.image.boundingBoxes![i];
      for(var o in points.last) {
        final pos = _getRelativePosition(o);
        final dx = pos.dx/_width;
        final dy = pos.dy/_height;
        if (bb.x+bb.width > dx && dx >bb.x && bb.y+bb.height > dy && dy >bb.y){
          nbCorrect += 1;
        }
        if (nbCorrect / points.last.length > 0.4) {
          isIn = true;
          isCorrect.last = true;
        }
      }
      i++;
    }
    if (!isIn) {
      widget.foundIncorrect();
    } else {
      widget.foundCorrect(i-1);
    }
  }

  double _clipScale(double currentScale, double newScale){
    final double finalScale = currentScale*newScale;
    return finalScale<_zoomMin
      ? _zoomMin/currentScale
      : (finalScale>_zoomMax
          ? _zoomMax/currentScale
          : newScale);
  }

  double _clipOffset(double size, double maxSize, double scale, double offset) {
    if (size * scale > maxSize) {
      return offset > -(maxSize - size) * scale /2
        ? - (maxSize - size) * scale /2
        : offset < -(maxSize-size)*scale/2-size*scale+maxSize
          ? -(maxSize-size)*scale/2-size*scale+maxSize
          : offset;
    } else {
      return -maxSize*(scale-1)/2;
    }
  }

  Matrix4 _appendTransformation(
    Matrix4 currentTransformation,
    double newScale,
    Offset translation,
    BoxConstraints constraints,
    Offset startPoint) {
    final Matrix4 newTransformation;
    if (newScale == 1) {
      // Only translate
      newTransformation = currentTransformation * Matrix4.identity()
        ..translate(
          (translation.dx-startPoint.dx)/currentTransformation.getMaxScaleOnAxis(), 
          (translation.dy-startPoint.dy)/currentTransformation.getMaxScaleOnAxis());
    } else {
      // zoom in/out
      final double currentScale = currentTransformation.getMaxScaleOnAxis();
      double finalScale = _clipScale(currentScale, newScale);
      final Offset imageFocalPoint = _transformationController.toScene(startPoint);
      newTransformation = currentTransformation * Matrix4.identity()
        ..translate(imageFocalPoint.dx, imageFocalPoint.dy)
        ..scale(finalScale)
        ..translate(-imageFocalPoint.dx, -imageFocalPoint.dy);
    }
    final imageBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    return Matrix4.identity()
      ..translate(
        _clipOffset(
          imageBox!.size.width,
          constraints.maxWidth,
          newTransformation.getMaxScaleOnAxis(),
          newTransformation.getTranslation()[0]),
        _clipOffset(
          imageBox.size.height,
          constraints.maxHeight,
          newTransformation.getMaxScaleOnAxis(),
          newTransformation.getTranslation()[1]))
      ..scale(newTransformation.getMaxScaleOnAxis());
  }

  void _onScaleStart(ScaleStartDetails details) {
    final containerBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    final containerPosition = containerBox!.localToGlobal(Offset.zero);
    _startFocalPoint = details.focalPoint-containerPosition;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      final containerBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
      final containerPosition = containerBox!.localToGlobal(Offset.zero);
      final Offset currentFocalPoint = details.focalPoint - containerPosition;
      currentTransformation = _appendTransformation(
        lastTransformation,
        details.scale,
        currentFocalPoint,
        constraints,
        _startFocalPoint
      );
      _transformationController.value = currentTransformation;
    });
  }

  void _onScaleEnd(ScaleEndDetails details, BoxConstraints constraints) {
      lastTransformation = currentTransformation;
  }
  Offset _getRelativePosition(Offset localPosition) {
    return localPosition-offset;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          key: _containerKey,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: InteractiveViewer(
              transformationController: _transformationController,
              panEnabled: false,
              scaleEnabled: false,
              child:GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapUp: (details){
                  if (!scaling){
                    points.add([details.localPosition]);
                    isCorrect.add(false);
                    setState(() {
                      isDrawing = false;
                      _isLastIn();
                    });
                  }
                },
                onScaleStart: (details){scaling = true;_onScaleStart(details);},
                onScaleUpdate: (details) {_onScaleUpdate(details, constraints);},
                onScaleEnd: (details){scaling = false;_onScaleEnd(details, constraints);},
                child:  Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      widget.image.path,
                      key: _imageKey),
                    for(int i = 0; i < points.length;i++)
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: ImagePainter(
                          points[i],
                          isCorrect[i],
                          i==points.length-1&&isDrawing),
                      ),
                    ],
                )
              )
            )
          )
        );
      }
    );
  }
}