import 'package:flutter/cupertino.dart';

class MuseumMapButton extends StatelessWidget {
  final VoidCallback onPressed;
  const MuseumMapButton({super.key, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 15),
            color: CupertinoColors.systemGrey4,
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/icons/square_split_bottomrightquarter.png',
                  width: 24,
                  height: 24,
                  color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
                ),
                const SizedBox(width: 8),
                const Text(
                  "Plan du musée",
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ],
            ),
          )
        )
      ]
    );
  }
  
}