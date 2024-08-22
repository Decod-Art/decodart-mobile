import 'package:flutter/cupertino.dart';

class ChevronButtonWidget extends StatelessWidget {
  final Widget? icon;
  final String text;
  final Color textColor;
  final Color chevronColor;
  final FontWeight fontWeight;
  final double fontSize;
  final double marginRight;
  final VoidCallback onPressed;
  const ChevronButtonWidget({
    super.key,
    this.icon,
    required this.text,
    this.textColor =CupertinoColors.darkBackgroundGray,
    this.chevronColor=CupertinoColors.systemGrey4,
    this.fontWeight=FontWeight.w400,
    this.fontSize=17,
    this.marginRight=10,
    required this.onPressed
    });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        children: [
          const SizedBox(width: 15),
          if (icon!=null) ...[
            icon!,
            const SizedBox(width: 8)
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  CupertinoIcons.right_chevron,
                  color: chevronColor,
                  size: 20
                ),
                SizedBox(width: marginRight)
              ],
            ),
          ),
        ],
      ),
    );
  }
}