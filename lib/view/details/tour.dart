import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:decodart/model/tour.dart' show Tour;
import 'package:decodart/api/tour.dart' show fetchTourById;
import 'package:decodart/widgets/formatted_content/formatted_content.dart' show ContentWidget;
import 'package:decodart/widgets/decod_bar.dart' show DecodNavigationBar;

class TourWidget extends StatefulWidget {
  // This widget shows a tour in a museum, in the city or even in both !
  final String title;
  final int tourId;
  const TourWidget({super.key, required this.title, required this.tourId});

  @override
  State<TourWidget> createState() => _TourWidgetState();
}

class _TourWidgetState extends State<TourWidget> {
  late Future<Tour> tourFuture;
  Tour? tour;

  @override
  void initState() {
    super.initState();
    tourFuture = fetchTourById(widget.tourId); // tour id... should be a Future in the end.
  }

  Widget _content() {
    return Container(
      color: Colors.black, // Définit la couleur de fond du Container à noir
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ContentWidget(
                items: tour!.description,
                alignment: WrapAlignment.start
              ),
            ]
          ),
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: DecodNavigationBar(title: widget.title),
      child: FutureBuilder<Tour>(
        future: tourFuture,
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
            tour = snapshot.data!;
            return _content();
          }
        },
      )
    );
  }
}