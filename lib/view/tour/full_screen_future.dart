// import 'package:decodart/model/tour.dart' show Tour;
// import 'package:decodart/view/tour/future_tour.dart' show FutureTourView;
// import 'package:flutter/cupertino.dart';

// class FullScreenFutureTourView extends StatelessWidget {
//   final Future<Tour> tour;
//   const FullScreenFutureTourView({
//     super.key,
//     required this.tour
//     });

  

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       child: CustomScrollView(
//         slivers: [
//           CupertinoSliverNavigationBar(
//             largeTitle: const Text('Parcours'),
//             trailing: CupertinoButton(
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 // Action à effectuer lors du tap sur l'icône
//               },
//               child: const Icon(
//                 CupertinoIcons.person_circle,
//                 color: CupertinoColors.activeBlue,
//                 size: 24
//               ),
//             ),
//           ),
//           SliverSafeArea(
//             sliver: SliverToBoxAdapter(
//               child: FutureTourView(tour: tour)
//             )
//           )
//         ]
//       )
//     );
//   }
// }