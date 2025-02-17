import 'package:flutter/cupertino.dart';

class ChevronButtonWidget extends StatelessWidget {
  final Widget? icon;
  final String text;
  final String? subtitle;
  final Color textColor;
  final Color subtitleColor;
  final Color chevronColor;
  final FontWeight fontWeight;
  final FontWeight subtitleFontWeight;
  final double fontSize;
  final double subtitleFontSize;
  final double marginRight;
  final VoidCallback onPressed;
  final bool chevronDown;
  final bool leadingSpace;
  const ChevronButtonWidget({
    super.key,
    this.icon,
    required this.text,
    this.textColor =CupertinoColors.darkBackgroundGray,
    this.subtitleColor =CupertinoColors.systemGrey4,
    this.chevronColor=CupertinoColors.systemGrey4,
    this.fontWeight=FontWeight.w400,
    this.subtitleFontWeight=FontWeight.w300,
    this.fontSize=17,
    this.subtitleFontSize=15,
    this.marginRight=10,
    required this.onPressed,
    this.subtitle,
    this.chevronDown=false,
    this.leadingSpace=false
    });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        children: [
          const SizedBox(width: 15),
          if (leadingSpace)
            const SizedBox(width: 16),
          if (icon!=null) ...[
            icon!,
            const SizedBox(width: 14)
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: subtitleFontSize,
                    fontWeight: subtitleFontWeight,
                  ),
                  textAlign: TextAlign.start,
                ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  chevronDown
                    ? CupertinoIcons.chevron_down
                    : CupertinoIcons.right_chevron,
                  color: chevronColor,
                  size: 20,
                  fill: 0,
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