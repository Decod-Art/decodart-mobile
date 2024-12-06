import 'package:decodart/model/image.dart' show AbstractImage;
import 'package:flutter/material.dart' show Colors, LayoutBuilder;
import 'package:flutter/cupertino.dart';

/// A custom painter that draws a circle at a given point on the canvas.
/// The color of the circle depends on whether the point is within a bounding box and whether the user is currently drawing.
class ImagePainter extends CustomPainter {
  final Offset point;
  final bool isCorrect;

  ImagePainter(this.point, this.isCorrect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isCorrect ? Colors.green : Colors.red).withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0;

    canvas.drawCircle(point, 15, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// A widget that displays an image with bounding boxes for a "Find Me" question in the Decod game.
/// The user must find and select the correct objects within the image by tapping on them.
/// The widget provides feedback for correct and incorrect selections and calculates the points based on the number of correct selections.
/// 
/// Attributes:
/// 
/// - `image` (required): An [AbstractImage] object representing the image with bounding boxes.
/// - `foundCorrect` (required): A [void Function(int)] callback that is called when a correct object is found.
/// - `foundIncorrect` (required): A [void Function()] callback that is called when an incorrect object is selected.
/// - `isOver` (required): A [bool] indicating whether the game is over.
/// - `isCorrect` (required): A [bool] indicating whether the last selection was correct.
class ImageDrawingWidget extends StatefulWidget {
  final AbstractImage image;
  /// Returns the index of the bounding box the use clicked on
  final void Function(int) foundCorrect;
  /// Indicates that the user clicked outside of any boundingbox
  final void Function() foundIncorrect;

  final bool readOnly;
  

  const ImageDrawingWidget({
    super.key,
    required this.image,
    required this.foundCorrect,
    required this.foundIncorrect,
    required this.readOnly
  });

  @override
  State<ImageDrawingWidget> createState() => _ImageDrawingWidgetState();
}

class _ImageDrawingWidgetState extends State<ImageDrawingWidget> {
  

  bool scaling = false;
  
  List<Offset> points = [];
  List<bool> isCorrect = [];

  /// keys permit to locate the correct position
  /// of the bounding boxes which are in relative coordinates
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();
  
  late Offset offset;
  Offset _startFocalPoint = Offset.zero;
  
  Matrix4 lastTransformation = Matrix4.identity();
  Matrix4 currentTransformation = Matrix4.identity();

  final double _zoomMax = 4, _zoomMin = 1;

  @override
  void didUpdateWidget(covariant ImageDrawingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      points.clear();
      isCorrect.clear();
      lastTransformation = Matrix4.identity();
      currentTransformation = Matrix4.identity();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  void _isLastIn(BoxConstraints constraints) {
    final renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    
    final double width = renderBox?.size.width??1;
    final double height = renderBox?.size.height??1;
    // calls the callbacks with respect to the last drawing done
    bool isIn = false;
    int i = 0;
    final offset = Offset((constraints.maxWidth-width)/2,(constraints.maxHeight-height)/2);
    final pos = points.last - offset;
    // x and y represents the relative coordinate of the click in the image
    final x = pos.dx/width;
    final y = pos.dy/height;
    // we loop over the bounding box until we find the image
    while (i < (widget.image.boundingBoxes?.length??0) && !isIn) {
      final bb = widget.image.boundingBoxes![i];
      // is the last point x, y in the bounding box
      if (bb.x+bb.width > x && x >bb.x && bb.y+bb.height > y && y >bb.y){
        isIn = true;
        isCorrect.last = true;
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
    final imageBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
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

      final Offset imageFocalPoint = (startPoint - Offset(
          currentTransformation.getTranslation().x,
          currentTransformation.getTranslation().y
        )) / currentScale;
      newTransformation = currentTransformation * Matrix4.identity()
        ..translate(imageFocalPoint.dx, imageFocalPoint.dy)
        ..scale(finalScale)
        ..translate(-imageFocalPoint.dx, -imageFocalPoint.dy);
    }
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
    });
  }

  void _onScaleEnd(ScaleEndDetails details, BoxConstraints constraints) {
      lastTransformation = currentTransformation;
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
            child: Transform(
              transform: currentTransformation,
              child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      widget.image.path,
                      key: _imageKey),
                    for(int i = 0; i < points.length;i++)
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: ImagePainter(points[i], isCorrect[i]),
                      ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapUp: !widget.readOnly
                        ? (details){
                            // The users is answering only
                            // if he's not scaling/zooming
                            if (!scaling){
                              points.add(details.localPosition);
                              isCorrect.add(false);
                              setState(() {_isLastIn(constraints);});
                            }
                          }
                        : null,
                      onScaleStart: (details){scaling = true;_onScaleStart(details);},
                      onScaleUpdate: (details) {_onScaleUpdate(details, constraints);},
                      onScaleEnd: (details){scaling = false;_onScaleEnd(details, constraints);},
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent
                      )
                    )
                  ],
                )
              )
            )
        );
      }
    );
  }
}