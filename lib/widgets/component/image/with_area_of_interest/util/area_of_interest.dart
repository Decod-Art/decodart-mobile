import 'package:decodart/model/image.dart' show BoundingBox;
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/cupertino.dart';

class AreaOfInterest extends StatelessWidget{
  final BoxConstraints constraints;
  final BoundingBox boundingBox;
  final double imageWidth;
  final double imageHeight;
  final Matrix4 currentTransformation;
  final VoidCallback onPressed;
  const AreaOfInterest({
    super.key,
    required this.constraints,
    required this.boundingBox,
    required this.imageWidth,
    required this.imageHeight,
    required this.currentTransformation,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final Matrix4 matrix = currentTransformation;

    final Offset offset = Offset(
      (constraints.maxWidth - imageWidth)/2,
      (constraints.maxHeight - imageHeight)/2);

    final Offset transformedOffset = MatrixUtils.transformPoint(
      matrix,
      Offset(
        imageWidth * boundingBox.center.dx+offset.dx,
        imageHeight * boundingBox.center.dy+offset.dy
      )
    );
    return Positioned(
      left: transformedOffset.dx-32,
      top: transformedOffset.dy-32,
      child: CupertinoButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
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
}