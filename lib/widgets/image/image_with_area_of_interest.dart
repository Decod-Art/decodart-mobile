import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:decodart/model/image.dart' show AbstractImage, BoundingBox;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageWithAreaOfInterest extends StatefulWidget {
  final AbstractImage image;
  final double x;
  final double y;

  const ImageWithAreaOfInterest({
    super.key,
    required this.image,
    this.x = 0.25,
    this.y = 0.25,
  });

  @override
  State<ImageWithAreaOfInterest> createState() => _ImageWithAreaOfInterestState();
}

class _ImageWithAreaOfInterestState extends State<ImageWithAreaOfInterest> with SingleTickerProviderStateMixin{
  final GlobalKey _imageKey = GlobalKey();
  double _imageWidth = 0;
  double _imageHeight = 0;
  bool showBoundingBox = true;
  late TransformationController _transformationController;
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;
  BoundingBox? selectedBox;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _zoomToBoundingBox([BoundingBox? b, double lambda=0.5]) {
    setState(() {
      selectedBox = b;
      if (b!=null) {
        showBoundingBox = false;
      }
    });
    final double scaleX = b!=null?1 / b.width:1;
    final double scaleY = b!=null?1 / b.height:1;
    final double scale = (b!=null)?(scaleX < scaleY ? scaleX : scaleY)*lambda+1-lambda:1;
    double translateX = b != null ? -b.center.dx * _imageWidth * scale + (_imageWidth / 2) : 0;
    double translateY = b != null ? -b.center.dy * _imageHeight * scale + (_imageHeight / 2) : 0;
    
    final double maxTranslateX = - _imageWidth * scale + _imageWidth;
    final double maxTranslateY = - _imageHeight * scale + _imageHeight;
    translateX = translateX<maxTranslateX?-_imageWidth*scale+_imageWidth:translateX;
    translateX = translateX>0?0:translateX;
    translateY = translateY<maxTranslateY?-_imageHeight*scale+_imageHeight:translateY;
    translateY = translateY>0?0:translateY;

    final Matrix4 endMatrix = Matrix4.identity()
      ..translate(translateX, translateY)
      ..scale(scale);

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward(from: 0);
    _animation.addListener(() {
      _transformationController.value = _animation.value;
    });
    
    _animation.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      // Code à exécuter lorsque l'animation est terminée
      if (selectedBox == null) {
        setState(() {
          showBoundingBox = true;
        });
      }
    }
  });
  }

  Widget _areaOfInterest(BoundingBox b){
    final Matrix4 matrix = _transformationController.value;
    final Offset transformedOffset = MatrixUtils.transformPoint(
      matrix, Offset(_imageWidth * b.center.dx, _imageHeight * b.center.dy));
    return Positioned(
      left: transformedOffset.dx-32,
      top: transformedOffset.dy-32,
      child: CupertinoButton(
        onPressed: () {
          _zoomToBoundingBox(b);
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

  void _postFrameCallback([bool updatedZoom=false]){
     WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _imageKey.currentContext!.findRenderObject() as RenderBox;
      if (_imageWidth != renderBox.size.width || _imageHeight != renderBox.size.height || updatedZoom){
        setState(() {
          _imageWidth = renderBox.size.width;
          _imageHeight = renderBox.size.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PrimaryScrollController(
          controller: ScrollController(),
          child: GestureDetector(
            onTap: () {
              if (selectedBox!=null){
                _zoomToBoundingBox();
              }
            },
            child: InteractiveViewer(
              transformationController: _transformationController,
              child: CachedNetworkImage(
                key: _imageKey,
                imageUrl: widget.image.path,
                placeholder: (context, url) => const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => const Icon(CupertinoIcons.exclamationmark_circle),
                fit: BoxFit.contain,
                imageBuilder: (context, imageProvider) {
                  _postFrameCallback();
                  return Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  );
                },
              ),
              onInteractionUpdate: (details){
                _postFrameCallback(true);
              },
            ),
          ),
        ),
        if (_imageWidth > 0 && _imageHeight > 0 && widget.image.boundingBoxes!=null && showBoundingBox)
          for (var b in widget.image.boundingBoxes!) ...[
            _areaOfInterest(b),
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
                      _zoomToBoundingBox();
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
    );
  }
}