import 'package:decodart/model/image.dart';
import 'package:flutter/cupertino.dart';

class DecodImage extends StatelessWidget {
  final AbstractImage image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const DecodImage(this.image, {super.key, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    return image.isDownloaded
      ? Image.memory(
        image.data!,
        width: width,
        height: height,
        fit: fit)
      : Image.network(
          image.path,
          width: width,
          height: height,
          fit: fit,
        );
  }
  
}