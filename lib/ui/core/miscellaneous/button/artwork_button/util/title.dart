import 'package:flutter/cupertino.dart';

class TitleAndSubtitle extends StatelessWidget {
  final double? bottom, left, right, top;
  final String title;
  final String subtitle;
  const TitleAndSubtitle({super.key, this.bottom=0, this.left=0, this.right=0, this.top, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CupertinoColors.transparent, CupertinoColors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}