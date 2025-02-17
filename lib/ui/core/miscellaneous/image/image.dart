import 'package:flutter/foundation.dart' show Uint8List;
import 'package:decodart/data/model/image.dart' show ImageOnline;
import 'package:decodart/util/logger.dart' show logger;
import 'package:flutter/cupertino.dart';

class DecodImage extends StatefulWidget {
  final ImageOnline image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool keepDataAfterDownload;
  final AlignmentGeometry alignment;
  final VoidCallback? onLoading;
  final VoidCallback? onError;
  const DecodImage(
    this.image, 
    {
      super.key,
      this.width,
      this.height,
      this.fit,
      this.keepDataAfterDownload=false,
      this.alignment=Alignment.center,
      this.onLoading,
      this.onError
    }
  );
  
  @override
  State<DecodImage> createState() => _DecodImageState();

}

class _DecodImageState extends State<DecodImage> {
  bool _isLoading = true;
  bool _hasFailed = false;
  late Uint8List imageData;

  @override
  void initState() {
    super.initState();
    downloadContent();

  }

  @override
  void didUpdateWidget(covariant DecodImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      downloadContent();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This is to have a callback when the image is actually rendered
  void _loadImage() {
    final ImageStream imageStream = Image.memory(imageData).image.resolve(ImageConfiguration.empty);
    final ImageStreamListener listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) => widget.onLoading?.call());
      }
    });
    imageStream.addListener(listener);
  }

  Future<void> downloadContent() async {
    setState(() {_isLoading = true;});
    try {
      imageData = await image.downloadImageData(keep: widget.keepDataAfterDownload);
    }catch(e) {
      _hasFailed = true;
      logger.e(e);
    }
    if(context.mounted) {
      setState(() {
        _isLoading = false;
      });
      if (!_hasFailed) {
        WidgetsBinding.instance.addPostFrameCallback((_)  => _loadImage());
      } else {
        widget.onError?.call();
      }
    }
  }

  ImageOnline get image => widget.image;
  double? get width => widget.width;
  double? get height => widget.height;
  BoxFit? get fit => widget.fit;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _isLoading
        ? SizedBox(width: width, height: height)
        : _hasFailed
            ? Image.asset(
                'images/img_404.jpeg',
                width: width,
                height: height,
                fit: fit,
                alignment: widget.alignment,
              )
            : Image.memory(
                imageData,
                width: width,
                height: height,
                fit: fit,
                alignment: widget.alignment,
              )
    );
  } 
}
