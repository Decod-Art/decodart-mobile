import 'package:flutter/cupertino.dart';

class InfoGallery extends StatelessWidget{
  const InfoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            children: [
              Image.asset(
                'images/icons/plus_magnifyingglass.png',
                width: 15,
                height: 15,
                color: CupertinoColors.systemGrey4, // Optionnel : pour colorer l'icône
              ),
              const SizedBox(width: 5,),
              const Expanded(
                child: Text(
                  'Touchez l\'image pour l\'ouvrir et obtenir les détails.',
                  style: TextStyle(color: CupertinoColors.systemGrey4, fontSize: 15),)
              )
            ]
          ),
        )
      ],
    );
  }

}