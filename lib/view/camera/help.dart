import 'package:flutter/cupertino.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Scanner une œuvre', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
          _HelpItem(
            number: '1',
            iconPath: 'images/icons/camera_viewfinder.png',
            description: 'Depuis l\'onglet "Scanner", pointez la caméra de votre téléphone sur une œuvre d\'art (de préférence de face). L\'œuvre peut se trouver dans la rue ou dans un musée.',
            size: 35
          ),
          _HelpItem(
            number: '2',
            iconPath: 'images/icons/textpage_badge_magnifyingglass.png',
            description: 'Si l\'œuvre est reconnue, vous pouvez accéder à la vue de l\'œuvre et découvrir ses détails et informations historiques.',
            size: 40
          ),
          _HelpItem(
            number: '3',
            iconPath: 'images/icons/clock.png',
            description: 'Après avoir scanné une œuvre, elle est automatiquement sauvegardée dans vos scans récents, dans l\'onglet "Scanner".',
            size: 35
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String number;
  final String iconPath;
  final String description;
  final double size;

  const _HelpItem({
    required this.number,
    required this.iconPath,
    required this.description,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        height: 130,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: CupertinoColors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  iconPath,
                  width: size,
                  height: size,
                  color: CupertinoColors.black
                ),
                
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.black,
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}