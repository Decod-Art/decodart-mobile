import 'package:flutter/cupertino.dart';

/// A widget that represents a preference tile with a title, an optional trailing widget, and an optional tap callback.
/// 
/// The `DecodPreferenceTile` is a stateless widget that displays a row with a title and an optional trailing widget.
/// It also supports an optional tap callback that is triggered when the tile is tapped.
/// 
/// Attributes:
/// 
/// - `title` (required): A [Widget] that represents the main content of the tile. Typically, this is a [Text] widget.
/// - `trailing` (optional): A [Widget] that is displayed at the end of the tile. This can be used to show additional information or an icon.
/// - `onTap` (optional): A [VoidCallback] that is triggered when the tile is tapped. This can be used to handle tap events on the tile.
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