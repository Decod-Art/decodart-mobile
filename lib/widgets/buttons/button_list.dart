import 'package:flutter/cupertino.dart';

class ButtonListWidget extends StatelessWidget {

  const ButtonListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Premier bouton
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Action pour le premier bouton
          },
          child: const Row(
            children: [
              SizedBox(width: 15),
              Icon(
                CupertinoIcons.person_circle,
                color: CupertinoColors.activeBlue,
              ),
              SizedBox(width: 8),
              Text(
                'À propos de l\'artiste',
                style: TextStyle(
                  color: CupertinoColors.darkBackgroundGray,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: CupertinoColors.systemGrey4,
                      size: 20
                    ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
            ],
          ),
        ),
        // Séparateur
        Padding(
          padding: const EdgeInsets.only(left: 45),
          child: Container(
            width: double.infinity,
            height: 1,
            color: CupertinoColors.systemGrey4,
          ),
        ),
        // Deuxième bouton
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Action pour le premier bouton
          },
          child: Row(
            children: [
              const SizedBox(width: 15),
              Image.asset(
                  'images/icons/text_book_closed.png',
                  width: 24,
                  height: 24,
                  color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
                ),
              const SizedBox(width: 8),
              const Text(
                'Contexte historique',
                style: TextStyle(
                  color: CupertinoColors.darkBackgroundGray,
                ),
              ),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: CupertinoColors.systemGrey4,
                      size: 20
                    ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}