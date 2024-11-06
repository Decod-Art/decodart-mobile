import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;
import 'package:flutter/cupertino.dart';

class ResultsView extends StatelessWidget {
  final List<ArtworkListItem> results;
  const ResultsView({
    super.key,
    required this.results
    });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Résultats possibles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 20), // Ajoute un espace entre le texte et l'image
          const Image(
            image: AssetImage('images/icons/photo_on_rectangle_angled.png'),
            width: 50.0,
            height: 50.0,
            color: CupertinoColors.systemGrey3
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Votre photo pourrait correspondre à plusieurs résultats',
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: CupertinoColors.systemGrey3,)),
          ),
          const SizedBox(height: 20),
          ListWithThumbnail(items: results, onPress: (item) async {
            showWidgetInModal(
              context,
              (context) => FutureArtworkView(artwork: item)
            );
          },)
        ]
      )
    );
  }
}

