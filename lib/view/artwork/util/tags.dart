import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/widgets/component/button/button_list.dart' show ButtonListWidget;
import 'package:decodart/widgets/component/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/component/formatted_content/content.dart' show ContentWidget;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;
import 'package:decodart/widgets/navigation/navigate_to_items.dart';
import 'package:flutter/cupertino.dart';

class ArtworkTags extends StatelessWidget {
  final Artwork artwork;
  const ArtworkTags({super.key, required this.artwork});
  @override
  Widget build(BuildContext context){
    return ButtonListWidget(
      buttons: [
        if (artwork.artist.hasBiography)
          ChevronButtonWidget(
            text: "À propos de l'artiste",
            icon: const Icon(
              CupertinoIcons.person_circle,
              color: CupertinoColors.activeBlue,
            ),
            onPressed: (){
              showWidgetInModal(
                context,
                (context) => ContentWidget(
                  items: artwork.artist.biography,
                  edges: const EdgeInsets.all(15)
                )
              );
            },
          ),
        if (artwork.hasMuseum)
          ChevronButtonWidget(
            text: artwork.museum.name,
            icon: Image.asset(
              'images/icons/museum.png',
              width: 24,
              height: 24,
              color: CupertinoColors.activeBlue,
            ),
            onPressed: (){
              navigateToMuseum(artwork.museum, context, modal: true);
            },
          ),
        for(final tag in artwork.sortedTags) ... [
          ChevronButtonWidget(
            text: tag.name,
            icon: Image.asset(
              _tagIconPath(tag.category.name),
              width: 24,
              height: 24,
              color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
            ),
            onPressed: (){
              showWidgetInModal(
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