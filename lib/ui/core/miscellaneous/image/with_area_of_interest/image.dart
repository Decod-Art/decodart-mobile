import 'package:decodart/data/model/image.dart' show ImageOnline, BoundingBox;
import 'package:decodart/ui/core/miscellaneous/image/image.dart' show DecodImage;
import 'package:decodart/ui/core/miscellaneous/image/with_area_of_interest/util/area_of_interest.dart' show AreaOfInterest;
import 'package:decodart/ui/core/miscellaneous/image/with_area_of_interest/util/description.dart' show Description;
import 'package:flutter/cupertino.dart';

class ImageWithAreaOfInterest extends StatefulWidget {
  final ImageOnline image;

  const ImageWithAreaOfInterest({
    super.key,
    required this.image,
  });

  @override
  State<ImageWithAreaOfInterest> createState() => _ImageWithAreaOfInterestState();
}

class _ImageWithAreaOfInterestState extends State<ImageWithAreaOfInterest> with SingleTickerProviderStateMixin{
  final GlobalKey _imageKey = GlobalKey();
  double _imageWidth = 0;
  double _imageHeight = 0;

  bool showLegend = false;
  bool showBoundingBox = true;
  bool manuallyHideBoundingBox = false;
  bool isZooming = false;
  
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;

  BoundingBox? selectedBox;

  Matrix4 currentTransformation = Matrix4.identity();
  Matrix4 lastTransformation = Matrix4.identity();

  late Offset _startFocalPoint;

  final double _zoomMax = 4, _zoomMin = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    setState(() {
      showBoundingBox = true;
      showLegend = false;
    });
    _animate(Matrix4.identity());
  }

  bool get showAreaOfInterest => _imageWidth + _imageHeight > 0 && widget.image.hasBoundingBox && showBoundingBox && !manuallyHideBoundingBox && !isZoomed;

  void _animate(Matrix4 destination){
    isZooming = true;
    _animation = Matrix4Tween(
      begin: currentTransformation,
      end: destination,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward(from: 0);
    _animation.addListener(() {
      setState(() {
        currentTransformation = _animation.value;
      });
    });
    
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isZooming = false;
        if (!showLegend&&!isZoomed) {
          setState(() {
            showBoundingBox = true;
            selectedBox = null;
          });
        }
      }
    });
  }

  void _zoomToBoundingBox(BoundingBox b, BoxConstraints constraints, [double lambda=0.5]) {
    setState(() {
      showLegend = true;
      selectedBox = b;
      showBoundingBox = false;
    });
    final double scaleX = 1/b.width;
    final double scaleY = 1/b.height;
    final double scale = (scaleX < scaleY ? scaleX : scaleY)*lambda+1-lambda;
    double translateX = -b.center.dx * _imageWidth * scale + (constraints.maxWidth / 2);
    double translateY = -b.center.dy * _imageHeight * scale + (constraints.maxHeight / 2);
    _zoomIn(scale, translateX, translateY, constraints);
  }


  void _zoomIn(double scale, double translateX, double translateY, BoxConstraints constraints) {
    final Offset offset = Offset(
      (constraints.maxWidth - _imageWidth)/2,
      (constraints.maxHeight - _imageHeight)/2
    );
    translateX -= offset.dx*scale;
    translateY -= offset.dy*scale;

    if (_imageWidth * scale >= constraints.maxWidth) {
      translateX = translateX < -offset.dx*scale
        ? translateX
        : -offset.dx*scale;
      translateX = translateX - constraints.maxWidth > -_imageWidth*scale-offset.dx*scale
        ? translateX
        : constraints.maxWidth-(_imageWidth+offset.dx)*scale;
    }

    if (_imageHeight * scale >= constraints.maxHeight) {
      translateY = translateY < -offset.dy*scale
        ? translateY
        : -offset.dy*scale;
      translateY = translateY - constraints.maxHeight > -_imageHeight*scale-offset.dy*scale
        ? translateY
        : constraints.maxHeight-(_imageHeight+offset.dy)*scale;
    }

    final Matrix4 endMatrix = Matrix4.identity()
      ..translate(translateX, translateY)
      ..scale(scale);

    _animate(endMatrix);
  }

  void _onImageLoaded(){
    final RenderBox renderBox = _imageKey.currentContext!.findRenderObject() as RenderBox;
    _imageWidth = renderBox.size.width;
    _imageHeight = renderBox.size.height;
    setState(() {});
  }

  bool get isZoomed => currentTransformation.getMaxScaleOnAxis() > 1+1e-9;

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
    Offset startPoint,
    BoxConstraints constraints) {
    final Matrix4 newTransformation;
    final imageBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    if (newScale == 1) {
      // Only translate
      newTransformation = currentTransformation * Matrix4.identity()
        ..translate(
          (translation.dx-startPoint.dx)/currentTransformation.getMaxScaleOnAxis(), 
          (translation.dy-startPoint.dy)/currentTransformation.getMaxScaleOnAxis());
    } else {
      final double currentScale = currentTransformation.getMaxScaleOnAxis();
      double finalScale = _clipScale(currentScale, newScale);
      
      final Offset focalPoint = (startPoint - Offset(
        currentTransformation.getTranslation().x,
        currentTransformation.getTranslation().y
      )) / currentScale;
      newTransformation = currentTransformation * Matrix4.identity()
        ..translate(focalPoint.dx, focalPoint.dy)
        ..scale(finalScale)
        ..translate(-focalPoint.dx, -focalPoint.dy);
    }

    return Matrix4.identity()
      ..translate(
        _clipOffset(
          imageBox!.size.width,
          screenWidth,
          newTransformation.getMaxScaleOnAxis(),
          newTransformation.getTranslation()[0]),
        _clipOffset(
          imageBox.size.height,
          screenHeight,
          newTransformation.getMaxScaleOnAxis(),
          newTransformation.getTranslation()[1]))
      ..scale(newTransformation.getMaxScaleOnAxis());
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startFocalPoint = details.focalPoint;
    lastTransformation = currentTransformation;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      currentTransformation = _appendTransformation(
        lastTransformation,
        details.scale,
        details.focalPoint,
        _startFocalPoint,
        constraints
      );
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
      lastTransformation = currentTransformation;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            if (!isZooming){
              if (selectedBox!=null || isZoomed){
                _resetZoom();
              } else {
                setState(() {
                  final isVisible = (showBoundingBox&&!manuallyHideBoundingBox);
                  showBoundingBox = !isVisible;
                  manuallyHideBoundingBox = isVisible;
                });
              }
            }
          },
          onScaleStart: _onScaleStart,
          onScaleUpdate: (details){_onScaleUpdate(details, constraints);},
          onScaleEnd: _onScaleEnd,
          child: Stack(
            children: [
              Transform(
                transform: currentTransformation,
                child: Center(
                  child: DecodImage(
                    widget.image,
                    key: _imageKey,
                    fit: BoxFit.contain,
                    onLoading: () {
                      if (_imageWidth == 0 && _imageHeight == 0) {
                        WidgetsBinding.instance.addPostFrameCallback((_) => _onImageLoaded());
                      }
                    },
                  )
                )
              ),
              if (showAreaOfInterest)
                for (var b in widget.image.boundingBoxes!) ...[
                  AreaOfInterest(
                    constraints: constraints,
                    boundingBox: b, 
                    imageWidth: _imageWidth,
                    imageHeight: _imageHeight, 
                    currentTransformation: currentTransformation,
                    onPressed: () => _zoomToBoundingBox(b, constraints)),
                ],
              Description(
                selectedBox: selectedBox,
                showLegend: showLegend,
                onReturnPressed: () => _resetZoom(),
              )
            ],
          )
        );
      }
    );
  }
}