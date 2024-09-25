import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/view/decod/game/manager.dart' show DecodView;
import 'package:flutter/cupertino.dart';

class DecodButton extends StatelessWidget {
  final Artwork artwork;
  const DecodButton({super.key, required this.artwork});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: CupertinoButton.filled(
              padding: const EdgeInsets.symmetric(vertical: 15),
              onPressed: () {
                Navigator.of(
                context, rootNavigator: true).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => DecodView(artwork: artwork,),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/icons/plus_magnifyingglass.png',
                    width: 24,
                    height: 24,
                    color: CupertinoColors.white, // Optionnel : pour colorer l'icône
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Décoder l'œuvre",
                    style: TextStyle(
                      color: CupertinoColors.white,
                    ),
                  ),
                ],
              ),
            )
          )
        ),
      ]
    );
  }
  
}