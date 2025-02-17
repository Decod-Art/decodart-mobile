import 'package:decodart/ui/core/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class ThanksScreen extends StatelessWidget {
  const ThanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'Remerciements',
      smallTitle: true,
      showTrailing: false,
      withScrolling: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Les applications Decod'Art sont les productions exclusives d'Élodie Cayuela, Romain Chailan, Valentin Leveau et Maximilien Servajean.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}