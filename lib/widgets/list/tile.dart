import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

enum ListNavigation {
  rootNavigator,
  tabNavigator,
  popup
}

class TileWidget<T extends Widget> extends StatelessWidget {
  final String title;
  final String subtitle;
  final String backgroundImageUrl;
  final T Function() view;
  final ListNavigation navigator;

  const TileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundImageUrl,
    required this.view,
    this.navigator=ListNavigation.tabNavigator
  });

  T createView() {
    return view();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Occupe toute la largeur
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(backgroundImageUrl),
          fit: BoxFit.cover, // Couvre toute la zone du container, en conservant les proportions
          alignment: Alignment.center, // Centre l'image
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft, // Aligner le contenu à gauche
        child: CupertinoButton(
          onPressed: () {
            if (navigator == ListNavigation.popup) {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height, // Couvre toute la hauteur de l'écran
                    color: CupertinoColors.black, // Fond blanc par défaut
                    child: createView(),
                  );
                },
              );
            } else {
              Navigator.of(context, rootNavigator: navigator == ListNavigation.rootNavigator).push(
                CupertinoPageRoute(builder: (context) => createView()),
              );
            }
          },
          padding: const EdgeInsets.all(16), // Ajustez selon vos besoins
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Pour que la colonne prenne la taille de son contenu
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow( // Ombre noire avec un décalage de 0 pour créer un effet dense
                      offset: Offset(0, 0),
                      blurRadius: 15.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4), // Espace entre le titre et le sous-titre
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9), // Légèrement transparent pour un meilleur contraste
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}