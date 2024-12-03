import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/geolocated.dart' show fetchAroundMe;
import 'package:decodart/api/museum.dart' show fetchAllMuseums;
import 'package:decodart/api/tour.dart' show fetchAllTours;
import 'package:decodart/controller_and_mixins/widgets/list/_util.dart' show DataFetcher;
import 'package:decodart/widgets/list/util/item_type.dart' show ItemType;
import 'package:decodart/widgets/navigation/navigate_to_items.dart' show navigateToArtwork, navigateToGeoLocated, navigateToMuseum, navigateToTour;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/museum.dart' show MuseumListItem;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/widgets/list/content_block/content_block.dart' show ContentBlock;
import 'package:decodart/widgets/component/error/error.dart' show ErrorView;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
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
        if (value.isEmpty) {
          _filter = null;
        }
        _setFetcher();
        setState(() {});
      },
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
                  onError: (_, __) {
                    setState(() {
                      errorAroundMe = true;
                    });
                  },
                ),
                ContentBlock(
                  fetch: fetchAllArtworks,
                  secondaryFetch: _artworkListItemFetcher.call,
                  onPressed: (item) => navigateToArtwork(item as ArtworkListItem, context),
                  title: 'Œuvres',
                  onError: (_, __) {
                    setState(() {
                      errorArtwork = true;
                    });
                  }
                ),
                ContentBlock(
                  fetch: fetchAllMuseums,
                  secondaryFetch: _museumListItemFetcher.call,
                  onPressed: (item) => navigateToMuseum(item as MuseumListItem, context),
                  itemType: (item) => ItemType.museum,
                  title: 'Musées',
                  onError: (_, __) {
                    setState(() {
                      errorMuseum = true;
                    });
                  }
                ),
                ContentBlock(
                  fetch: fetchAllTours,
                  secondaryFetch: _tourListItemFetcher.call,
                  onPressed: (item) => navigateToTour(item as TourListItem, context),
                  itemType: (item) => ItemType.tour,
                  title: 'Visites',
                  onError: (_, __) {
                    setState(() {
                      errorTour = true;
                    });
                  }
                ),
              ]
            )
          : ErrorView(onPress: _reset)
      ]
    );
  }
}