import 'package:flutter/cupertino.dart';

class InfoLogo extends StatelessWidget {
  const InfoLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(
          CupertinoIcons.info_circle_fill,
          color: CupertinoColors.white,
          size: 18
        ),
      ),
    );
  }
}