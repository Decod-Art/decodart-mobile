
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/museum.dart' show MuseumListItem;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/future_museum.dart' show FutureMuseumView;
import 'package:decodart/view/tour/future_tour.dart' show FutureTourView;
import 'package:decodart/widgets/navigation/modal.dart' show WidgetBuilder, showWidgetInModal;
import 'package:decodart/widgets/navigation/screen.dart' show navigateToWidget;
import 'package:flutter/cupertino.dart' show BuildContext;

void navigateToGeoLocated(GeolocatedListItem item, BuildContext context, {bool modal=false}) {
  if (item.isMuseum) {
    navigateToMuseum(MuseumListItem.fromGeolocatedListItem(item), context, modal: modal);
  } else {
    navigateToArtwork(ArtworkListItem.fromGeolocatedListItem(item), context, modal: modal);
  }
}

void navigateToArtwork(ArtworkListItem item, BuildContext context, {bool modal=false}) {
  _navigateToWidget((context) => FutureArtworkView(artwork: item), context, modal: modal);
}

void navigateToMuseum(MuseumListItem item, BuildContext context, {bool modal=false}) {
  _navigateToWidget((context) => FutureMuseumView(museum: item, useModal: modal), context, modal: modal);
}

void navigateToTour(TourListItem item, BuildContext context, {bool modal=false}) {
  _navigateToWidget((context) => FutureTourView(tour: item), context, modal: modal);
}

void _navigateToWidget(WidgetBuilder builder, BuildContext context, {bool modal=false}) {
  if (modal) {
    showWidgetInModal(context, builder);
  } else {
    navigateToWidget(context, builder);
  }
}