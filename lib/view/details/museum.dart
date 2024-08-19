import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:decodart/api/museum.dart' show fetchMuseumById;
import 'package:decodart/api/tour.dart' show fetchExhibitionByMuseum, fetchTourByMuseum;
import 'package:decodart/api/artwork.dart' show fetchArtworkByMuseum;


import 'package:decodart/widgets/formatted_content/formatted_content.dart';
import 'package:decodart/widgets/list/tile.dart';
import 'package:decodart/widgets/decod_bar.dart' show DecodNavigationBar;
import 'package:decodart/widgets/list/list_future.dart' show ListFutureWidget;

import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/museum.dart' show Museum;

import 'package:decodart/view/details/tour.dart' show TourWidget;
import 'package:decodart/view/details/artwork/artwork.dart' show ArtworkDetailsWidget;

class MuseumWidget extends StatefulWidget {
  // This widget shows a tour in a museum, in the city or even in both !
  final String title;
  final int museumId;

  const MuseumWidget({super.key, required this.title, required this.museumId});

  @override
  State<MuseumWidget> createState() => _MuseumWidgetState();
}

class _MuseumWidgetState extends State<MuseumWidget> {
  late Future<Museum> museumFuture;

  @override
  void initState() {
    super.initState();
    museumFuture = fetchMuseumById(widget.museumId);
  }
  Widget _content(Museum museum) {
    return Container(
      color: Colors.black, // Définit la couleur de fond du Container à noir
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (museum.hasCollection)
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: false).push(
                        CupertinoPageRoute(builder: (context) => ListFutureWidget(
                          listName: 'Collection',
                          listContent: fetchArtworkByMuseum(museum.uid!),
                          onClick: (AbstractListItem item) => ArtworkDetailsWidget(artworkId: item.uid!),
                          navigator: ListNavigation.popup,)
                        ),
                      );
                    },
                    child: const Text('Collection'),
                  ),
                if (museum.hasExhibitions)
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: false).push(
                        CupertinoPageRoute(builder: (context) => ListFutureWidget(
                          listName: 'Exposition',
                          listContent: fetchExhibitionByMuseum(museum.uid!),
                          onClick: (AbstractListItem item) => TourWidget(title: item.title, tourId: item.uid!),
                          navigator: ListNavigation.tabNavigator,)
                        ),
                      );
                    },
                    child: const Text('Exposition'),
                  ),
                if (museum.hasTours)
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: false).push(
                        CupertinoPageRoute(builder: (context) => ListFutureWidget(
                          listName: 'Parcours',
                          listContent: fetchTourByMuseum(museum.uid!),
                          onClick: (AbstractListItem item) => TourWidget(title: item.title, tourId: item.uid!),
                          navigator: ListNavigation.tabNavigator,)
                        ),
                      );
                    },
                  child: const Text('Parcours'),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ContentWidget(
                      items: museum.description,
                      alignment: WrapAlignment.start
                    ),
                  ]
                ),
              )
            )
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: DecodNavigationBar(title: widget.title),
      child: FutureBuilder<Museum>(
        future: museumFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.black, // Définit la couleur de fond du Container à noir
              width: double.infinity,
              height: double.infinity,
              child: const Center(child: CircularProgressIndicator())
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur lors du chargement des données'));
          } else {
            Museum museum = snapshot.data!;
            return _content(museum);
          }
        },
      )
    );
  }
}