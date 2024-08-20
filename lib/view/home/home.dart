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
import 'package:decodart/view/map/map.dart' show MapView;
import 'item_tab.dart' show ItemTab;
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.map),
            activeIcon: Icon(CupertinoIcons.map_fill),
            label: 'Carte'),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera),
            activeIcon: Icon(CupertinoIcons.camera_fill),
            label: 'Scanner'),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.compass),
            activeIcon: Icon(CupertinoIcons.compass_fill),
            label: 'Explorer'),
          BottomNavigationBarItem(
            icon: Image.asset(
                'images/icons/questionmark_bubble.png',
                width: 30,
                height: 30,
                color: CupertinoColors.systemGrey, // Optionnel : pour colorer l'icône
              ),
            activeIcon: Image.asset(
                'images/icons/questionmark_bubble_fill.png',
                width: 30,
                height: 30,
                color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
              ),
            label: 'Décoder'),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                _cachedOnMap ??= fetchAllOnMap();
                return MapView(markers: _cachedOnMap!);
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
              case 3:
                _cachedTours ??= fetchAllTours();
                return ListFutureWidget(
                  listName: 'Parcours',
                  listContent: _cachedTours!,
                  onClick: (AbstractListItem item) => TourWidget(title: item.title, tourId: item.uid!));
              case 4:
                return const DecodTab();
              default:
                return MapView(markers: _cachedOnMap!);
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