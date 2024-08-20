import 'package:flutter/cupertino.dart';

class ChevronButtonWidget extends StatelessWidget {
  final bool showIcon;
  final Color iconColor;
  final String iconPath;
  final String text;
  final Color textColor;
  final Color chevronColor;
  final FontWeight fontWeight;
  final double fontSize;
  final double marginRight;
  const ChevronButtonWidget({
    super.key,
    this.showIcon=true,
    this.iconColor=CupertinoColors.activeBlue,
    this.iconPath='images/icons/text_book_closed.png',
    required this.text,
    this.textColor =CupertinoColors.darkBackgroundGray,
    this.chevronColor=CupertinoColors.systemGrey4,
    this.fontWeight=FontWeight.w400,
    this.fontSize=17,
    this.marginRight=10
    });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // Action pour le premier bouton
      },
      child: Row(
        children: [
          const SizedBox(width: 15),
          if (showIcon) ...[
            Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: iconColor, // Optionnel : pour colorer l'icône
              ),
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