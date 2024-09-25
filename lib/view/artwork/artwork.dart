import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/view/artwork/decod_button.dart' show DecodButton;
import 'package:decodart/widgets/buttons/button_list.dart' show ButtonListWidget;
import 'package:decodart/widgets/buttons/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/formatted_content/formatted_content.dart' show ContentWidget;
import 'package:decodart/widgets/image/gallery.dart' show ImageGallery;
import 'package:decodart/widgets/modal_or_fullscreen/modal_or_fullscreen.dart' show showModal;
import 'package:flutter/cupertino.dart';

class ArtworkView extends StatelessWidget {
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
            style: const TextStyle(fontSize: 20)
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
                showModal(
                  context,
                  (context) => ContentWidget(
                    items: artwork.artist.biography,
                    edges: const EdgeInsets.all(15)
                  )
                );
              },
            ),
            for(final tag in artwork.tags) ... [
              ChevronButtonWidget(
                text: tag.name,
                icon: Image.asset(
                  _tagIconPath(tag.category.name),
                  width: 24,
                  height: 24,
                  color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
                ),
                onPressed: (){
                  showModal(
                    context,
                    (context) => ContentWidget(
                      items: tag.description,
                      edges: const EdgeInsets.all(15)
                    )
                  );
                },
              )
            ]
          ],
        ),
        const SizedBox(height: 5),
        if(artwork.hasDecodQuestion)
          DecodButton(artwork: artwork),
        const SizedBox(height: 20),
        ImageGallery(
          images: artwork.images
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: ContentWidget(
              items: artwork.description,
            )
          ),
      ],
    );
  }
}

String _tagIconPath(String name){
  switch (name) {
    case "Technique artistique":
      return "images/icons/paintbrush_pointed.png";
    case "Sujet":
      return "images/icons/photo_artframe.png";
    case "Mouvement artistique":
      return "person_crop_square";
    default:
      return "images/icons/text_book_closed.png";
  }
}