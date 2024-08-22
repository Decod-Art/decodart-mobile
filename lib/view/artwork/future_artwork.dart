import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/view/artwork/artwork.dart' show ArtworkView;
import 'package:flutter/cupertino.dart';

class FutureArtworkView extends StatelessWidget {
  final Future<Artwork> artwork;
  const FutureArtworkView({
    super.key,
    required this.artwork
    });

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Artwork>(
      future: artwork,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erreur : ${snapshot.error}',
              style: const TextStyle(color: CupertinoColors.systemRed),
            ),
          );
        } else if (snapshot.hasData) {
          final artwork = snapshot.data!;
          return ArtworkView(artwork: artwork);
        } else {
          return const Center(
            child: Text('Aucune donnée disponible'),
          );
        }
      },
    );
  }
}