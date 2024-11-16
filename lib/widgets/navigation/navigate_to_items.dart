
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/museum.dart' show MuseumListItem;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/future_museum.dart' show FutureMuseumView;
import 'package:decodart/view/tour/future_tour.dart' show FutureTourView;
import 'package:decodart/widgets/navigation/screen.dart' show navigateToWidget;
import 'package:flutter/cupertino.dart';

void navigateToGeoLocated(AbstractListItem item, BuildContext context) {
    if ((item as GeolocatedListItem).isMuseum) {
      navigateToMuseum(MuseumListItem.fromGeolocatedListItem(item), context);
    } else {
      navigateToArtwork(ArtworkListItem.fromGeolocatedListItem(item), context);
    }
  }

  void navigateToArtwork(AbstractListItem item, BuildContext context) {
    navigateToWidget(
      context,
      (context) => FutureArtworkView(artwork: item as ArtworkListItem),
    );
  }

  void navigateToMuseum(AbstractListItem item, BuildContext context) {
    navigateToWidget(
      context,
      (context) => FutureMuseumView(museum: item as MuseumListItem, useModal: false),
    );
  }

  void navigateToTour(AbstractListItem item, BuildContext context) {
    navigateToWidget(
      context,
      (context) => FutureTourView(tour: item as TourListItem),
    );
  }