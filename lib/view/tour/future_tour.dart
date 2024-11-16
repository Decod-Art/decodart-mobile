import 'package:decodart/api/tour.dart' show fetchTourById;
import 'package:decodart/model/tour.dart' show Tour, TourListItem;
import 'package:decodart/view/tour/tour.dart' show TourView;
import 'package:decodart/widgets/util/wait_future.dart' show WaitFutureWidget;
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