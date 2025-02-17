import 'package:decodart/data/model/artwork.dart' show ArtworkForeignKey, ArtworkListItem;
import 'package:decodart/data/model/tour.dart' show Tour;
import 'package:decodart/ui/artwork/widgets/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/ui/core/miscellaneous/formatted_content/content.dart' show ContentWidget;
import 'package:decodart/ui/core/list/widgets/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/ui/core/navigation/modal.dart' show showWidgetInModal;
import 'package:flutter/cupertino.dart';

class TourView extends StatelessWidget {
  final Tour tour;
  const TourView({
    super.key,
    required this.tour});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            tour.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Liste des œuvres à découvrir",
            style: TextStyle(
              fontWeight: FontWeight.w400, 
              fontSize: 22,)),
          const SizedBox(height: 5,),
          ListWithThumbnail<ArtworkForeignKey>(
            items: tour.artworks,
            onPress: (artwork){
              showWidgetInModal(context, (context) => FutureArtworkView(artwork: artwork));
            },),
          const SizedBox(height: 5),
          ContentWidget(
            items: tour.description,
            onButtonPressed: (item){
              showWidgetInModal(context, (context) => FutureArtworkView(artwork: item as ArtworkListItem));
            },
          ),
          const SizedBox(height: 35)
        ],
      )
    );
  }
}