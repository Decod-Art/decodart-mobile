import 'package:decodart/model/tour.dart' show Tour;
import 'package:decodart/view/tour/future_tour.dart' show FutureTourView;
import 'package:decodart/widgets/new_decod_bar.dart' show NewDecodNavigationBar;
import 'package:flutter/cupertino.dart';

class FullScreenFutureTourView extends StatelessWidget {
  final Future<Tour> tour;
  const FullScreenFutureTourView({
    super.key,
    required this.tour
    });

  

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: NewDecodNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
              SizedBox(width: 4),
              Text('Retour', style: TextStyle(color: CupertinoColors.activeBlue)),
            ],
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
            child: FutureTourView(tour: tour)
        )
      )
    );
  }
}