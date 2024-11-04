import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/geolocated.dart' show fetchAroundMe;
import 'package:decodart/api/museum.dart' show fetchAllMuseums;
import 'package:decodart/api/tour.dart' show fetchAllTours;
import 'package:decodart/api/util.dart' show Fetcher, LazyList;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/museum.dart' show MuseumListItem;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/future_museum.dart' show FutureMuseumView;
import 'package:decodart/view/tour/future_tour.dart';
import 'package:decodart/widgets/list/content_block.dart' show ContentBlock;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/modal_or_fullscreen/modal_or_fullscreen.dart' show navigateToWidget;
import 'package:decodart/widgets/new/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final LazyList<TourListItem> _tours = LazyList(fetch: fetchAllTours);
  late Fetcher<GeolocatedListItem> _geolocatedListItemFetcher;
  late Fetcher<ArtworkListItem> _artworkListItemFetcher;
  late Fetcher<MuseumListItem> _museumListItemFetcher;
  String? _filter;

  @override
  void initState() {
    super.initState();
    _fetchTours();
    _setGeoLocatedFetcher();
    _setArtworkFetcher();
    _setMuseumFetcher();
  }

  void _setGeoLocatedFetcher() {
    _geolocatedListItemFetcher = Fetcher(
      fetch: ({
        int limit=10, int offset=0
      }) => fetchAroundMe(limit: limit, offset: offset, query: _filter)
    );
  }

  void _setArtworkFetcher() {
    _artworkListItemFetcher = Fetcher(
      fetch: ({
        int limit=10, int offset=0
      }) => fetchAllArtworks(limit: limit, offset: offset, query: _filter)
    );
  }

  void _setMuseumFetcher() {
    _museumListItemFetcher = Fetcher(
      fetch: ({
        int limit=10, int offset=0
      }) => fetchAllMuseums(limit: limit, offset: offset, query: _filter)
    );
  }

  Future<void> _fetchTours() async {
    await _tours.fetchMore();
    setState(() {});
  }

  void _onAroundMePressed(AbstractListItem item) {
    final geoItem = item as GeolocatedListItem;
    if (geoItem.isMuseum) {      
      _onMuseumPressed(MuseumListItem.fromGeolocatedListItem(item));
    } else {
      _onArtworkPressed(ArtworkListItem.fromGeolocatedListItem(item));
    }
  }

  void _onArtworkPressed(AbstractListItem item) {
    navigateToWidget(
      context,
      (context) => FutureArtworkView(artwork: item as ArtworkListItem),
    );
  }

  void _onMuseumPressed(AbstractListItem item) {
    navigateToWidget(
      context,
      (context) => FutureMuseumView(museum: item as MuseumListItem, useModal: false),
    );
  }

  void _onTourPressed(AbstractListItem item) {
    navigateToWidget(
      context,
      (context) => FutureTourView(tour: item as TourListItem),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'Explorer',
      onSearch: (String value) {
        _filter = value;
        if (value.isEmpty) {
          _filter = null;
        }
        _setGeoLocatedFetcher();
        _setArtworkFetcher();
        _setMuseumFetcher();
        setState(() {});
      },
      children: [
        Column(// Column so that it is a single widget in the scaffold.. And queries only done once.
          children: [
            ContentBlock(
              fetch: fetchAroundMe,
              secondaryFetch: _geolocatedListItemFetcher.call,          
              onPressed: _onAroundMePressed,
              isMuseum: (item) => item.isMuseum,
              title: 'Autour de moi',
            ),
            ContentBlock(
              fetch: fetchAllArtworks,
              secondaryFetch: _artworkListItemFetcher.call,
              onPressed: _onArtworkPressed,
              title: 'Œuvres'
            ),
            ContentBlock(
              fetch: fetchAllMuseums,
              secondaryFetch: _museumListItemFetcher.call,
              onPressed: _onMuseumPressed,
              title: 'Musées'
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Visites",
                    style: TextStyle(
                      color: CupertinoColors.darkBackgroundGray,
                      fontSize: 22,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ),
                ListWithThumbnail(items: _tours.list, onPress: _onTourPressed,)
              ],
            )
          ],
        ),
      ]
    );
  }
}