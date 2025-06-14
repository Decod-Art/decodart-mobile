import 'package:decodart/data/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/data/api/geolocated.dart' show fetchAroundMe;
import 'package:decodart/data/api/museum.dart' show fetchAllMuseums;
import 'package:decodart/data/api/tour.dart' show fetchAllTours;
import 'package:decodart/ui/core/list/util/_util.dart' show DataFetcher;
import 'package:decodart/ui/core/list/widgets/components/item_type.dart' show ItemType;
import 'package:decodart/ui/core/navigation/navigate_to_items.dart' show navigateToArtwork, navigateToGeoLocated, navigateToMuseum, navigateToTour;
import 'package:decodart/data/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/data/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/data/model/museum.dart' show MuseumListItem;
import 'package:decodart/data/model/tour.dart' show TourListItem;
import 'package:decodart/ui/core/list/widgets/content_block/content_block.dart' show ContentBlock;
import 'package:decodart/ui/core/miscellaneous/error/error.dart' show ErrorView;
import 'package:decodart/ui/core/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

/// A widget that displays the explore view in the Decod app.
/// 
/// The `ExploreView` is a stateful widget that shows various categories of items (artworks, museums, tours, and geolocated items) in a list format.
/// It fetches data from different APIs and displays the items in content blocks. The user can search for items and navigate to detailed views of the items.
/// 
/// Attributes:
/// 
/// - `key` (optional): A [Key] to uniquely identify the widget.
class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  // The fetcher are encapsulated in methods so that when the build method is called
  // to regenerate the widget, the Widgets that gets reconstructed don't receive a new "item"
  // (i.e.) a new fetcher... They are the same object with just an updated parameter...
  // Otherwise the widgets get reconstructed each time something happens that change the fetcher
  late DataFetcher<GeolocatedListItem> _geolocatedListItemFetcher;
  bool errorAroundMe = false;
  late DataFetcher<ArtworkListItem> _artworkListItemFetcher;
  bool errorArtwork = false;
  late DataFetcher<MuseumListItem> _museumListItemFetcher;
  bool errorMuseum = false;
  late DataFetcher<TourListItem> _tourListItemFetcher;
  bool errorTour = false;
  String? _filter;

  @override
  void initState() {
    super.initState();
    _setFetcher();
  }

  bool get hasError => errorAroundMe && errorArtwork && errorMuseum && errorTour;
  bool get hasNoError => !hasError;

  void _setFetcher() {
    _setGeoLocatedFetcher();
    _setArtworkFetcher();
    _setMuseumFetcher();
    _setTourFetcher();
  }

  void _reset() {
    errorAroundMe = false;
    errorArtwork = false;
    errorMuseum = false;
    errorTour = false;
    _setFetcher();
    setState(() {});
  }

  void _setGeoLocatedFetcher() {
    _geolocatedListItemFetcher = ({
        int limit=10, int offset=0
      }) => fetchAroundMe(limit: limit, offset: offset, query: _filter);
  }

  void _setArtworkFetcher() {
    _artworkListItemFetcher = ({
        int limit=10, int offset=0
      }) => fetchAllArtworks(limit: limit, offset: offset, query: _filter);
  }

  void _setTourFetcher() {
    _tourListItemFetcher = ({
        int limit=10, int offset=0
      }) => fetchAllTours(limit: limit, offset: offset, query: _filter);
  }

  void _setMuseumFetcher() {
    _museumListItemFetcher = ({
        int limit=10, int offset=0
      }) => fetchAllMuseums(limit: limit, offset: offset, query: _filter);
  }

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'Explorer',
      smallTitle: false,
      onSearch: (String value) {
        _filter = value;
        if (value.isEmpty) _filter = null;
        _setFetcher();
        setState(() {});
      },
      canPop: false,
      children: [
        hasNoError
          ? Column(// Column so that it is a single widget in the scaffold.. And queries only done once.
              children: [
                ContentBlock(
                  fetch: fetchAroundMe,
                  secondaryFetch: _geolocatedListItemFetcher.call,          
                  onPressed: (item) => navigateToGeoLocated(item as GeolocatedListItem, context),
                  itemType: (item) => item.isMuseum ? ItemType.museum : ItemType.artwork,
                  title: 'Autour de moi',
                  onError: (_, __) => setState(() {errorAroundMe = true;})
                ),
                ContentBlock(
                  fetch: fetchAllArtworks,
                  secondaryFetch: _artworkListItemFetcher.call,
                  onPressed: (item) => navigateToArtwork(item as ArtworkListItem, context),
                  title: 'Œuvres',
                  onError: (_, __) => setState(() {errorArtwork = true;})
                ),
                ContentBlock(
                  fetch: fetchAllMuseums,
                  secondaryFetch: _museumListItemFetcher.call,
                  onPressed: (item) => navigateToMuseum(item as MuseumListItem, context),
                  itemType: (item) => ItemType.museum,
                  title: 'Musées',
                  onError: (_, __) => setState(() {errorMuseum = true;})
                ),
                ContentBlock(
                  fetch: fetchAllTours,
                  secondaryFetch: _tourListItemFetcher.call,
                  onPressed: (item) => navigateToTour(item as TourListItem, context),
                  itemType: (item) => ItemType.tour,
                  title: 'Visites',
                  onError: (_, __) => setState(() {errorTour = true;})
                ),
              ]
            )
          : ErrorView(onPress: _reset)
      ]
    );
  }
}