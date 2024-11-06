import 'package:flutter/cupertino.dart';

class DecodPreferenceTile extends StatelessWidget {
  final Widget title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const DecodPreferenceTile({super.key, required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.0, // Utilisez 0.0 pour une ligne fine
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            title,
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}