import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/view/decod/manager.dart' show DecodView;
import 'package:decodart/widgets/buttons/button_list.dart' show ButtonListWidget;
import 'package:decodart/widgets/buttons/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/formatted_content/formatted_content_scrolling.dart' show ContentScrolling;
import 'package:decodart/widgets/image/gallery.dart' show ImageGallery;
import 'package:decodart/widgets/modal/modal.dart' show ShowModal;
import 'package:flutter/cupertino.dart';

class ArtworkView extends StatelessWidget with ShowModal{
  final Artwork artwork;
  const ArtworkView({
    super.key,
    required this.artwork
    });

  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            artwork.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
          child: Text(
            "${artwork.artist.name}, ${artwork.year}",
            style: const TextStyle(
              fontSize: 20
            )
          )
        ),
        const SizedBox(height: 20),
        ButtonListWidget(
          buttons: [
            ChevronButtonWidget(
              text: "À propos de l'artiste",
              icon: const Icon(
                CupertinoIcons.person_circle,
                color: CupertinoColors.activeBlue,
              ),
              onPressed: (){
                showDecodModalBottomSheet(
                  context,
                  (context) => ContentScrolling(
                    text: artwork.artist.biography,
                    edges: const EdgeInsets.all(15)),
                  expand: true,
                  useRootNavigator: true);
                
              },
            ),
            ChevronButtonWidget(
              text: "Contexte historique",
              icon: Image.asset(
                'images/icons/text_book_closed.png',
                width: 24,
                height: 24,
                color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
              ),
              onPressed: (){
                showDecodModalBottomSheet(
                  context,
                  (context) => ContentScrolling(
                    text: artwork.context.description,
                    edges: const EdgeInsets.all(15)),
                  expand: true,
                  useRootNavigator: true);
              },
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
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
                      pageBuilder: (context, animation, secondaryAnimation) => DecodView(artworkId: artwork.uid!,),
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
        ),
        const SizedBox(height: 20),
        ImageGallery(
          images: artwork.images
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: ContentScrolling(
              text: artwork.description,
            )
          ),
        // Ajoutez d'autres widgets pour afficher les autres propriétés de l'artwork
      ],
    );
  }
}