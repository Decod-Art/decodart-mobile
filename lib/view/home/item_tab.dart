import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/model/museum.dart' show MuseumListItem;
import 'package:decodart/view/details/artwork/artwork.dart' show ArtworkDetailsWidget;
import 'package:decodart/view/details/museum.dart' show MuseumWidget;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:decodart/widgets/list/tile.dart' show ListNavigation;
import 'package:decodart/widgets/list/list_with_tabs.dart' show TabListWidget;


class ItemTab extends StatefulWidget {
  final String listName;
  final Future<List<ArtworkListItem>> artworks;
  final Future<List<MuseumListItem>> museums;
  final Future<List<GeolocatedListItem>> onMap;
  final ListNavigation navigator;

  const ItemTab({
    super.key,
    required this.listName,
    required this.artworks,
    required this.museums,
    required this.onMap,
    this.navigator=ListNavigation.tabNavigator});
  @override
  State<ItemTab> createState() => _ItemTabState();
}

class _ItemTabState extends State<ItemTab> {
  
  Future<List<List<AbstractListItem>>> fetchData() {
    return Future.wait([widget.onMap, widget.artworks, widget.museums]);
  }

  @override
  Widget build(BuildContext context) {
    return TabListWidget(
      content: fetchData(),
      tabs: const {
        'map': 'Sur la carte',
        'artwork': 'Œuvres',
        'museum': 'Musées'
      },
      onClickWidget: (AbstractListItem item) {
        bool isMuseum = (item is GeolocatedListItem && item.isMuseum) || item is MuseumListItem;
        if (isMuseum) {
          return () => MuseumWidget(title: item.title, museumId: item.uid!);
        } else {
          return () => ArtworkDetailsWidget(artworkId: item.uid!);
        }
      },
      onClickNavigator: (AbstractListItem item) {
        bool isMuseum = (item is GeolocatedListItem && item.isMuseum) || item is MuseumListItem;
        if (isMuseum) {
          return ListNavigation.tabNavigator;
        } else {
          return ListNavigation.popup;
        }
      },
    );
  }
}