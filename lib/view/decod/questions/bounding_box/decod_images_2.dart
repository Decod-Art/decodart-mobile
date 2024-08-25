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
      //canvas.drawCircle(points[0], 30, paint);
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
  late double _width;
  bool shouldRepaint = true;
  bool isDrawing = false;
  late double _height;
  List<List<Offset>> points = [];
  List<bool> isCorrect = [];
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getImageDimensions();
    });
  }

  void _getImageDimensions() {
    final renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    final containerBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && containerBox != null) {
      setState(() {
        _width = renderBox.size.width;
        _height = renderBox.size.height;
      });
    }
  }

  @override
  void didUpdateWidget(covariant ImageDrawingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      points.clear();
      isCorrect.clear();
      shouldRepaint = true;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  void _isLastIn() {
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
        if (nbCorrect / points.length > 0.5) {
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



  Offset _getRelativePosition(Offset localPosition) {
    final renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    final containerBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && containerBox != null) {
      final imagePosition = renderBox.localToGlobal(Offset.zero);
      final containerPosition = containerBox.localToGlobal(Offset.zero);
      final offset = imagePosition - containerPosition;
      return localPosition-offset;
    }
    return localPosition;
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
          child: Stack(
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
              Positioned.fill(
                  child: GestureDetector(
                    onPanStart: widget.isOver?null:(details) {
                      points.add([]);
                      isCorrect.add(false);
                      isDrawing = true;
                    },
                    onPanUpdate: widget.isOver?null:(details) {
                      setState(() {
                        points.last.add(details.localPosition);
                      });
                    },
                    onPanEnd: widget.isOver?null:(details) {
                      setState(() {
                        isDrawing = false;
                        _isLastIn();
                      });
                    },
                  ),
                ),
              ],
          )
        );
      }
    );
  }
}