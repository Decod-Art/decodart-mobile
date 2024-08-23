import 'package:decodart/api/artwork.dart' show fetchAllArtworks, fetchArtworkById;
import 'package:decodart/api/geolocated.dart' show fetchAroundMe;
import 'package:decodart/api/museum.dart' show fetchAllMuseums, fetchMuseumById;
import 'package:decodart/api/tour.dart' show fetchAllTours, fetchTourById;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/museum.dart' show MuseumListItem;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/view/artwork/full_screen_future.dart' show FullScreenFutureArtworkView;
import 'package:decodart/view/list/list.dart' show SliverListViewPage;
import 'package:decodart/view/museum/full_screen_future.dart' show FullScreenFutureMuseumView;
import 'package:decodart/view/tour/full_screen_future.dart' show FullScreenFutureTourView;
import 'package:decodart/widgets/list/list_with_thumbnail.dart';
import 'package:decodart/widgets/set_block.dart' show SetBlock;
import 'package:flutter/cupertino.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  List<GeolocatedListItem> aroundMe = [];
  List<ArtworkListItem> artworks = [];
  List<MuseumListItem> museums = [];
  List<TourListItem> tours = [];
  @override
  void initState() {
    super.initState();
    _fetchAroundMe();
    _fetchArtworks();
    _fetchMuseums();
    _fetchTours();
  }

  void _fetchAroundMe() async {
    aroundMe.addAll(await fetchAroundMe());
    setState(() {});
  }

  void _fetchArtworks() async {
    artworks.addAll(await fetchAllArtworks());
    setState(() {});
  }

  void _fetchMuseums() async {
    museums.addAll(await fetchAllMuseums());
    setState(() {});
  }

  void _fetchTours() async {
    tours.addAll(await fetchAllTours());
    setState(() {});
  }

  void _onAroundMePressed(AbstractListItem item) {
    final geoItem = item as GeolocatedListItem;
    if (geoItem.isMuseum) {
      final futureMuseum = fetchMuseumById(item.uid);
      
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => FullScreenFutureMuseumView(museum: futureMuseum),
        ),
      );
    } else {
      final futureArtwork = fetchArtworkById(item.uid);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => FullScreenFutureArtworkView(artwork: futureArtwork),
        ),
      );
    }
  }

  void _onArtworkPressed(AbstractListItem item) {
    final futureArtwork = fetchArtworkById(item.uid!);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FullScreenFutureArtworkView(artwork: futureArtwork),
      ),
    );
  }

  void _onMuseumPressed(AbstractListItem item) {
    final futureMuseum = fetchMuseumById(item.uid!);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FullScreenFutureMuseumView(museum: futureMuseum),
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
                  // Action à effectuer lors de la saisie dans le champ de recherche
                },
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // Action à effectuer lors du tap sur l'icône
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
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SetBlock(
                    name: 'Autour de moi',
                    items: aroundMe,
                    onPressed: _onAroundMePressed,
                    isMuseum: (item)=>(item as GeolocatedListItem).isMuseum,
                    onTitlePressed: (){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SliverListViewPage(
                              title: 'Autour de moi',
                              items: aroundMe,
                              onPress: _onAroundMePressed,),
                          ),
                        );
                    },
                  ),
                  SetBlock(
                    name: 'Œuvres',
                    items: artworks,
                    onPressed: _onArtworkPressed,
                    isMuseum: (item)=>false,
                    onTitlePressed: (){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SliverListViewPage(
                              title: 'Œuvres',
                              items: artworks,
                              onPress: _onArtworkPressed,),
                          ),
                        );
                    },
                  ),
                  SetBlock(
                    name: 'Musées',
                    items: museums,
                    onPressed: _onMuseumPressed,
                    isMuseum: (item)=>true,
                    onTitlePressed: (){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SliverListViewPage(
                              title: 'Musées',
                              items: museums,
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
                      ListWithThumbnail(items: tours, onPress: _onTourPressed,)
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