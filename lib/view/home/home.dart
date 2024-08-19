// Model
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/museum.dart' show MuseumListItem;
import 'package:decodart/model/tour.dart' show TourListItem;

// view
import 'package:decodart/view/details/tour.dart' show TourWidget;

import 'package:flutter/cupertino.dart';

// Tabs
import 'item_tab.dart' show ItemTab;
import 'map_tab.dart' show MapTab;
import 'camera_tab.dart' show CameraTabWidget;
import 'package:decodart/view/home/decod_tab.dart' show DecodTab;


// API
import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/geolocated.dart' show fetchAllOnMap;
import 'package:decodart/api/museum.dart' show fetchAllMuseums;
import 'package:decodart/api/tour.dart' show fetchAllTours;

// Widgets
import 'package:decodart/widgets/list/list_future.dart' show ListFutureWidget;

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<ArtworkListItem>>? _cachedArtworks;
  Future<List<GeolocatedListItem>>? _cachedOnMap;
  Future<List<MuseumListItem>>? _cachedMuseums;
  Future<List<TourListItem>>? _cachedTours;
  final CupertinoTabController _tabController = CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      backgroundColor: CupertinoColors.black,
      tabBar: CupertinoTabBar(
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.map),
            label: 'Carte'),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Liste'),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) => const CameraTabWidget()
                  ),
                );
              },
              child: const IconTheme(
                data: IconThemeData(size: 50, color: Color.fromARGB(255, 175, 175, 175)), // Rend l'icône de la caméra plus grande
                child: Icon(CupertinoIcons.camera),
              )
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.map_pin_ellipse),
            label: 'Parcours'),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.infinite),
            label: 'Décoder'),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                _cachedOnMap ??= fetchAllOnMap();
                return MapTab(markers: _cachedOnMap!);
              case 1:
                _cachedArtworks ??= fetchAllArtworks();
                _cachedMuseums ??= fetchAllMuseums();
                _cachedOnMap ??= fetchAllOnMap();
                return ItemTab(
                  artworks: _cachedArtworks!,
                  museums: _cachedMuseums!, // _cachedMuseums!
                  onMap: _cachedOnMap!,
                  listName: 'À voir'
                );
              case 2:
                return const HomePage();
              case 3:
                _cachedTours ??= fetchAllTours();
                return ListFutureWidget(
                  listName: 'Parcours',
                  listContent: _cachedTours!,
                  onClick: (AbstractListItem item) => TourWidget(title: item.title, tourId: item.uid!));
              case 4:
                return const DecodTab();
              default:
                return const HomeTab();
            }
          },
        );
      },
    );
  }

  void changeTab(int index) {
    _tabController.index = index; // Ou utilisez _tabController.animateTo(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Accueil')),
      child: Center(
        child: CupertinoButton(
          child: const Text('Aller à la page de détails'),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const DetailPage()),
            );
          },
        ),
      ),
    );
  }
}

// Créez des widgets pour SearchTab, CameraTab, FavoritesTab, et ProfileTab de manière similaire à HomeTab

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Page de détails')),
      child: Center(
        child: CupertinoButton(
          child: const Text('Retour'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}