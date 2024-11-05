import 'package:decodart/model/artwork.dart' show ArtworkForeignKey, ArtworkListItem;
import 'package:decodart/model/tour.dart' show Tour;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/widgets/formatted_content/formatted_content.dart' show ContentWidget;
import 'package:decodart/widgets/new/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/new/navigation/modal.dart' show showWidgetInModal;
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
          const Text(
            "Liste des œuvres à découvrir",
            style: TextStyle(
              fontWeight: FontWeight.w500, 
              fontSize: 22,)),
          const SizedBox(height: 5,),
          ListWithThumbnail<ArtworkForeignKey>(
            items: tour.artworks,
            onPress: (artwork){
              showWidgetInModal(context, (context) => FutureArtworkView(artwork: artwork));
            },),
          const SizedBox(height: 5),
          Text(
            tour.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500, 
              fontSize: 22,)),
          ContentWidget(
            items: tour.description,
            onButtonPressed: (item){
              showWidgetInModal(context, (context) => FutureArtworkView(artwork: item as ArtworkListItem));
            },
          )
        ],
      )
    );
  }
}