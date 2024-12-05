import 'package:decodart/view/decod/menu/util/history.dart' show DecodedHistory;
import 'package:decodart/view/decod/menu/util/stats/stats.dart' show StatsWidget;
import 'package:decodart/view/decod/menu/util/train_to_decod/train_to_decod.dart' show TrainToDecod;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

/// A widget that represents the main menu view for the Decod feature.
/// 
/// The `DecodMainMenuView` is a stateless widget that displays the main menu for the Decod feature.
/// It includes statistics, a history of decoded items, and a training section.
/// 
/// Attributes:
/// 
/// - `key` (optional): A [Key] to uniquely identify the widget.
class DecodMainMenuView extends StatelessWidget {
  const DecodMainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'Décoder',
      smallTitle: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const StatsWidget(),
          const Expanded(
            flex: 3,
            // DecodedHistory is a scrollable widget of the artworks that have been decoded
            child: DecodedHistory(),
          ),
          Container(
            color: CupertinoColors.systemGrey6,
            width: double.infinity,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: const TrainToDecod()
            )
          )
        ]
      ),
    );
  }
}