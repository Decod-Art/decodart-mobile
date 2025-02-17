import 'package:decodart/data/api/tour.dart' show fetchTourById;
import 'package:decodart/data/model/tour.dart' show Tour, TourListItem;
import 'package:decodart/ui/tour/tour.dart' show TourView;
import 'package:decodart/ui/core/util/wait_future.dart' show WaitFutureWidget;
import 'package:flutter/cupertino.dart';

class FutureTourView extends StatelessWidget {
  final TourListItem tour;
  const FutureTourView({
    super.key,
    required this.tour
    });

  

  @override
  Widget build(BuildContext context) {
    return WaitFutureWidget<Tour>(
      fetch: () => fetchTourById(tour.uid!),
      builder: (tour) => TourView(tour: tour,)
    );
  }
}