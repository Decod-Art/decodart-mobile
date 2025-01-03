import 'package:decodart/model/image.dart' show ImageOnline;
import 'package:decodart/util/logger.dart';
import 'package:flutter/cupertino.dart';

class DecodImage extends StatefulWidget {
  final ImageOnline image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool deleteContentOnDispose;
  const DecodImage(
    this.image, 
    {
      super.key,
      this.width,
      this.height,
      this.fit,
      this.deleteContentOnDispose=false
    }
  );
  
  @override
  State<DecodImage> createState() => _DecodImageState();

}

class _DecodImageState extends State<DecodImage> {
  bool _isLoading = true;
  bool _hasFailed = false;

  @override
  void initState() {
    super.initState();
    if (widget.image.isDownloaded) {
      _isLoading = false;
    } else {
      downloadContent();
    }

  }

  @override
  void dispose() {
    if (widget.deleteContentOnDispose) {
      image.clearImageData();
    }
    super.dispose();
  }

  Future<void> downloadContent() async {
    try {
      await image.downloadImageData();
    }catch(e) {
      _hasFailed = true;
      logger.e(e);
    }
    if(context.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  ImageOnline get image => widget.image;
  double? get width => widget.width;
  double? get height => widget.height;
  BoxFit? get fit => widget.fit;
  @override
  Widget build(BuildContext context) {
    return _isLoading
    ? Container(
        width: width,
        height: height,
        color: CupertinoColors.systemGrey5,
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      )
    : _hasFailed
        ? Image.asset(
            'images/img_404.jpeg',
            width: width,
            height: height,
            fit: fit,
          )
        : Image.memory(
            image.data!,
            width: width,
            height: height,
            fit: fit,
          );
  }
  
}