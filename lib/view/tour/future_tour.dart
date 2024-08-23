import 'package:decodart/model/tour.dart' show Tour;
import 'package:flutter/cupertino.dart';

class FutureTourView extends StatelessWidget {
  final Future<Tour> tour;
  const FutureTourView({
    super.key,
    required this.tour
    });

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tour>(
      future: tour,
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
          final tour = snapshot.data!;
          return const Text('It works!');
        } else {
          return const Center(
            child: Text('Aucune donnée disponible'),
          );
        }
      },
    );
  }
}