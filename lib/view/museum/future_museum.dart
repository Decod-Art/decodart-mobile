import 'package:decodart/api/museum.dart' show fetchMuseumById;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/view/museum/museum.dart' show MuseumView;
import 'package:flutter/cupertino.dart';

class FutureMuseumView extends StatefulWidget {
  final int museumId;

  const FutureMuseumView({
    super.key,
    required this.museumId
    });
    
    @override
    State<FutureMuseumView> createState() => _FutureMuseumViewState();

}

class _FutureMuseumViewState extends State<FutureMuseumView> {
  late Future<Museum> museum;

  @override
  void initState(){
    super.initState();
    museum = fetchMuseumById(widget.museumId);
  }

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