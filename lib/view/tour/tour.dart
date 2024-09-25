import 'package:decodart/api/artwork.dart' show fetchArtworkById;
import 'package:decodart/model/artwork.dart' show ArtworkForeignKey, ArtworkListItem;
import 'package:decodart/model/tour.dart' show Tour;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/widgets/formatted_content/formatted_content.dart' show ContentWidget;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/modal_or_fullscreen/modal.dart' show ShowModal;
import 'package:flutter/cupertino.dart';

class TourView extends StatelessWidget with ShowModal {
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
              showDecodModalBottomSheet(
                context,
                (context) => FutureArtworkView(artwork: artwork),
                expand: true,
                useRootNavigator: true);
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
              showDecodModalBottomSheet(
                context,
                (context) => FutureArtworkView(artwork: item as ArtworkListItem),
                expand: true,
                useRootNavigator: true);
            },
          )
        ],
      )
    );
  }
}