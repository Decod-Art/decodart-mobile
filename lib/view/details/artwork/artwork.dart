import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, CircularProgressIndicator;

import 'package:decodart/api/artwork.dart' show fetchArtworkById;
import 'package:decodart/model/artwork.dart' show Artwork;
import 'animated.dart' show AnimatedArtworkView;

class ArtworkDetailsWidget extends StatefulWidget {
  final int artworkId;

  const ArtworkDetailsWidget({super.key, required this.artworkId});

  @override
  State<ArtworkDetailsWidget> createState() => _ArtworkDetailsWidgetState();
}

class _ArtworkDetailsWidgetState extends State<ArtworkDetailsWidget> {
  late Future<Artwork> artworkFuture;

  @override
  void initState() {
    super.initState();
    // Initialisez le Future ici pour charger les données lorsque le widget est créé
    artworkFuture = fetchArtworkById(widget.artworkId);
  }
  @override
  Widget build(BuildContext context) {
    // Show a loading screen
    return FutureBuilder<Artwork?>(
      future: artworkFuture, // Le Future que FutureBuilder surveille
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Les données sont encore en train de charger
          return Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: CircularProgressIndicator()
            )
          );
        } else if (snapshot.hasError) {
          // Une erreur s'est produite lors du chargement des données
          return const Center(child: Text('Erreur lors du chargement des données'));
        } else {
          // Les données sont chargées, construisez votre widget avec les données
          final Artwork artwork = snapshot.data!;
          return Center(
            // Utilisez les données de l'artwork pour construire votre widget
            child: AnimatedArtworkView(artwork: artwork)
          );
        }
      },
    );
  }
}
