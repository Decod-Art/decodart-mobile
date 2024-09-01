import 'package:decodart/api/artwork.dart' show fetchAllArtworks, fetchArtworkById;
import 'package:decodart/api/geolocated.dart' show fetchAroundMe;
import 'package:decodart/api/museum.dart' show fetchAllMuseums, fetchMuseumById;
import 'package:decodart/api/tour.dart' show fetchAllTours, fetchTourById;
import 'package:decodart/api/util.dart' show LazyList;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/view/apropos/apropos.dart' show AproposView;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/list/lazy_list.dart' show SliverLazyListView;
import 'package:decodart/view/museum/full_screen_future.dart' show FullScreenFutureMuseumView;
import 'package:decodart/view/tour/full_screen_future.dart' show FullScreenFutureTourView;
import 'package:decodart/widgets/list/horizontal_list_with_header.dart' show LazyHorizontalListWithHeader;
import 'package:decodart/widgets/list/list_with_thumbnail.dart';
import 'package:flutter/cupertino.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  LazyList<TourListItem> tours = LazyList(fetch: fetchAllTours);
  String? filter;
  @override
  void initState() {
    super.initState();
    _fetchTours();
  }

  Future<void> _fetchTours() async {
    await tours.fetchMore();
    setState(() {});
  }

  void _onAroundMePressed(AbstractListItem item) {
    final geoItem = item as GeolocatedListItem;
    if (geoItem.isMuseum) {      
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => FullScreenFutureMuseumView(museumId: item.uid),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => FutureArtworkView(
            artworkId: item.uid,
            fullScreen: true,),
        ),
      );
    }
  }

  void _onArtworkPressed(AbstractListItem item) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FutureArtworkView(
          artworkId: item.uid!,
          fullScreen: true,),
      ),
    );
  }

  void _onMuseumPressed(AbstractListItem item) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FullScreenFutureMuseumView(museumId: item.uid!),
      ),
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
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Padding(
              padding: const EdgeInsets.only(right: 25, left: 5),
              child: CupertinoSearchTextField(
                placeholder: 'Rechercher',
                onChanged: (String value) {
                  filter = value;
                  if (value.isEmpty) {
                    filter = null;
                  }
                  setState(() {});
                },
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const AproposView()),
                );
              },
              child: const Icon(
                CupertinoIcons.person_circle,
                color: CupertinoColors.activeBlue,
                size: 24
              ),
            ),
            middle: const Text('Explorer')
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  LazyHorizontalListWithHeader(
                    name: 'Autour de moi',
                    fetch: ({int limit=10, int offset=0}) {return fetchAroundMe(limit: limit, offset: offset, query: filter);},
                    onPressed: _onAroundMePressed,
                    isMuseum: (item)=>(item as GeolocatedListItem).isMuseum,
                    onTitlePressed: (){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SliverLazyListView(
                              title: 'Autour de moi',
                              fetch: fetchAroundMe,
                              onPress: _onAroundMePressed,),
                          ),
                        );
                    },
                  ),
                  LazyHorizontalListWithHeader(
                    name: 'Œuvres',
                    fetch: ({int limit=10, int offset=0}) {return fetchAllArtworks(limit: limit, offset: offset, query: filter);},
                    onPressed: _onArtworkPressed,
                    isMuseum: (item)=>false,
                    onTitlePressed: (){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SliverLazyListView(
                              title: 'Œuvres',
                              fetch: fetchAllArtworks,
                              onPress: _onArtworkPressed,),
                          ),
                        );
                    },
                  ),
                  LazyHorizontalListWithHeader(
                    name: 'Musées',
                    fetch: ({int limit=10, int offset=0}) {return fetchAllMuseums(limit: limit, offset: offset, query: filter);},
                    onPressed: _onMuseumPressed,
                    isMuseum: (item)=>true,
                    onTitlePressed: (){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SliverLazyListView(
                              title: 'Œuvres',
                              fetch: fetchAllMuseums,
                              onPress: _onMuseumPressed,),
                          ),
                        );
                    },
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
                      ListWithThumbnail(items: tours.list, onPress: _onTourPressed,)
                    ],
                  )
                ]
              ),
            ),
          )
        ],
      ),
    );
  }
}