
import 'package:decodart/data/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/data/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/data/model/museum.dart' show MuseumListItem, MuseumForeignKey;
import 'package:decodart/data/model/tour.dart' show TourListItem;
import 'package:decodart/ui/artwork/widgets/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/ui/museum/widgets/future_museum.dart' show FutureMuseumView;
import 'package:decodart/ui/tour/future_tour.dart' show FutureTourView;
import 'package:decodart/ui/core/navigation/modal.dart' show WidgetBuilder, showWidgetInModal;
import 'package:decodart/ui/core/navigation/screen.dart' show navigateToWidget;
import 'package:flutter/cupertino.dart' show BuildContext;

void navigateToGeoLocated(GeolocatedListItem item, BuildContext context, {bool modal=false}) {
  if (item.isMuseum) {
    navigateToMuseum(MuseumListItem.fromGeolocatedListItem(item), context, modal: modal);
  } else {
    navigateToArtwork(ArtworkListItem.fromGeolocatedListItem(item), context, modal: modal);
  }
}

void navigateToArtwork(ArtworkListItem item, BuildContext context, {bool modal=false}) {
  _navigateToWidget((context) => FutureArtworkView(artwork: item), context, modal: modal, threshold: 55);
}

void navigateToMuseum(MuseumForeignKey item, BuildContext context, {bool modal=false}) {
  _navigateToWidget((context) => FutureMuseumView(museum: item, useModal: modal), context, modal: modal);
}

void navigateToTour(TourListItem item, BuildContext context, {bool modal=false}) {
  _navigateToWidget((context) => FutureTourView(tour: item), context, modal: modal, threshold: 55);
}

void _navigateToWidget(WidgetBuilder builder, BuildContext context, {bool modal=false, double? threshold}) {
  if (modal) {
    showWidgetInModal(context, builder);
  } else {
    navigateToWidget(context, builder, threshold: threshold);
  }
}