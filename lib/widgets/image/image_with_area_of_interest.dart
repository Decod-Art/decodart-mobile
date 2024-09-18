import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:decodart/model/image.dart' show AbstractImage, BoundingBox;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageWithAreaOfInterest extends StatefulWidget {
  final AbstractImage image;

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
      selectedBox = null;
    });
    _animate(Matrix4.identity());
  }

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
        if (selectedBox == null&&!_isZoomed()) {
          setState(() {
            showBoundingBox = true;
          });
        }
      }
    });
  }

  void _zoomToBoundingBox(BoundingBox b, BoxConstraints constraints, [double lambda=0.5]) {
    setState(() {
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

  Widget _areaOfInterest(BoundingBox b, BoxConstraints constraints){
    final Matrix4 matrix = currentTransformation;

    final Offset offset = Offset(
      (constraints.maxWidth - _imageWidth)/2,
      (constraints.maxHeight - _imageHeight)/2);

    final Offset transformedOffset = MatrixUtils.transformPoint(
      matrix,
      Offset(
        _imageWidth * b.center.dx+offset.dx,
        _imageHeight * b.center.dy+offset.dy
      )
    );
    return Positioned(
      left: transformedOffset.dx-32,
      top: transformedOffset.dy-32,
      child: CupertinoButton(
        onPressed: () {
          _zoomToBoundingBox(b, constraints);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            CupertinoIcons.info,
            color: Colors.white,
          ),
        ),
      )
    );
  }

  void _onImageLoaded(){
    final RenderBox renderBox = _imageKey.currentContext!.findRenderObject() as RenderBox;
    _imageWidth = renderBox.size.width;
    _imageHeight = renderBox.size.height;
    setState(() {});
  }

  bool _isZoomed() {
    return currentTransformation.getMaxScaleOnAxis() > 1+1e-9;
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
              if (selectedBox!=null || _isZoomed()){
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
                  child: Image.network(
                    widget.image.path,
                    key: _imageKey,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (_imageWidth == 0 && _imageHeight == 0) {
                        WidgetsBinding.instance.addPostFrameCallback((_) => _onImageLoaded());
                      }
                      return child;
                    },
                  )
                )
              ),
              if (_imageWidth > 0 && _imageHeight > 0 && widget.image.boundingBoxes!=null && showBoundingBox && !manuallyHideBoundingBox && !_isZoomed())
                for (var b in widget.image.boundingBoxes!) ...[
                  _areaOfInterest(b, constraints),
                ],
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                bottom: selectedBox!=null ? 0 : -200, // Adjust the height as needed
                left: 0,
                right: 0,
                child: Container(
                  height: 200, // Adjust the height as needed
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicWidth(
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Ajustez les marges internes si nécessaire
                          onPressed: () {
                            _resetZoom();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5), // Fond noir transparent
                              borderRadius: BorderRadius.circular(30), // Extrémités arrondies
                            ),
                            padding: const EdgeInsets.only(left: 10, right: 15, top: 5, bottom: 5), // Ajustez les marges internes si nécessaire
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(CupertinoIcons.arrow_left, color: Colors.white, size: 16,),
                                SizedBox(width: 10,),
                                Text("Retour", style: TextStyle(color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          selectedBox?.description??"",
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        );
      }
    );
  }
}