import 'package:flutter/cupertino.dart';

// Tabs
import 'package:decodart/view/map/map.dart' show MapView;
import 'package:decodart/view/camera/camera.dart' show CameraView;
import 'package:decodart/view/explore/explore.dart' show ExploreView;
import 'package:decodart/view/decod/menu/main_menu.dart' show DecodMainMenuView;

/// A widget that represents the home page of the Decod app.
/// 
/// The `HomePage` is a stateful widget that displays a tab bar with four tabs: Map, Scanner, Explore, and Decod.
/// Each tab displays a different view when selected.
/// 
/// Attributes:
/// 
/// - `key` (optional): A [Key] to uniquely identify the widget.
class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CupertinoTabController _tabController = CupertinoTabController();
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: false,
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
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) => const MapView(),
            );
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) => const CameraView(),
            );
          case 2:
            return CupertinoTabView(
              builder: (BuildContext context) => const ExploreView(),
            );
          case 3:
            return CupertinoTabView(
              builder: (BuildContext context) => const DecodMainMenuView(),
            );
          default:
            return Container();
        }
      }
    );
  }

  set tab (int index) {
    _tabController.index = index;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}