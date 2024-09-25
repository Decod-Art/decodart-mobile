import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/geolocated.dart' show fetchAroundMe;
import 'package:decodart/api/museum.dart' show fetchAllMuseums;
import 'package:decodart/api/tour.dart' show fetchAllTours, fetchTourById;
import 'package:decodart/api/util.dart' show LazyList;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/museum.dart' show MuseumListItem;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/future_museum.dart' show FutureMuseumView;
import 'package:decodart/widgets/list/content_block.dart' show ContentBlock;
import 'package:decodart/view/tour/full_screen_future.dart' show FullScreenFutureTourView;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/modal_or_fullscreen/modal_or_fullscreen.dart' show navigateToWidget;
import 'package:decodart/widgets/modal_or_fullscreen/page_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final LazyList<TourListItem> _tours = LazyList(fetch: fetchAllTours);
  String? _filter;

  @override
  void initState() {
    super.initState();
    _fetchTours();
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
    final futureTour = fetchTourById(item.uid!);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FullScreenFutureTourView(tour: futureTour),
      ),
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
        setState(() {});
      },
      children: [
        ContentBlock(
          fetch: fetchAroundMe,
          secondaryFetch: ({int limit=10, int offset=0}) {return fetchAroundMe(limit: limit, offset: offset, query: _filter);},
          isModal: false,
          onPressed: _onAroundMePressed,
          title: 'Autour de moi',
        ),
        ContentBlock(
          fetch: fetchAllArtworks,
          secondaryFetch: ({int limit=10, int offset=0}) {return fetchAllArtworks(limit: limit, offset: offset, query: _filter);},
          isModal: false,
          onPressed: _onArtworkPressed,
          title: 'Œuvres'
        ),
        ContentBlock(
          fetch: fetchAllMuseums,
          secondaryFetch: ({int limit=10, int offset=0}) {return fetchAllMuseums(limit: limit, offset: offset, query: _filter);},
          isModal: false,
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
      ]
    );
  }
}