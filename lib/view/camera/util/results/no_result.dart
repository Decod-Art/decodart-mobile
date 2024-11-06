import 'package:flutter/cupertino.dart';


class NoResultWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const NoResultWidget({
    super.key,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          CupertinoIcons.clear_circled_solid,
          color: CupertinoColors.systemGrey3,
          size: 30.0, // Taille de l'icône
        ),
        const SizedBox(height: 5), // Espace entre l'icône et le texte
        const Text(
          "Votre photo n'a pas pu être reconnue",
          style: TextStyle(
            fontSize: 16,
            color: CupertinoColors.systemGrey3,
          ),
        ),
        const SizedBox(height: 10), // Espace entre le texte et le bouton
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.activeBlue,
            borderRadius: BorderRadius.circular(15), // Bords arrondis
          ),
          height: 30,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), // Hauteur plus petite
            onPressed: onPressed,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.camera_fill,
                  color: CupertinoColors.white,
                  size: 20.0, // Taille de l'icône de la caméra
                ),
                SizedBox(width: 5), // Espace entre l'icône et le texte
                Text(
                  "Réessayer",
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}