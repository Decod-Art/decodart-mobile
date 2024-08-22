import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/view/museum/museum.dart' show MuseumView;
import 'package:flutter/cupertino.dart';

class FutureMuseumView extends StatelessWidget {
  final Future<Museum> museum;
  const FutureMuseumView({
    super.key,
    required this.museum
    });

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Museum>(
      future: museum,
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
          final museum = snapshot.data!;
          return MuseumView(museum: museum);
        } else {
          return const Center(
            child: Text('Aucune donnée disponible'),
          );
        }
      },
    );
  }
}