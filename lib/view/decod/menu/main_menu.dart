import 'package:decodart/api/decod.dart' show fetchTags;
import 'package:decodart/model/decod.dart' show DecodTag;
import 'package:decodart/view/decod/menu/util/history.dart' show DecodedHistory;
import 'package:decodart/view/decod/menu/util/stats/stats.dart' show StatsWidget;
import 'package:decodart/view/decod/menu/util/train_to_decod/train_to_decod.dart' show TrainToDecod;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class DecodMainMenuView extends StatefulWidget {
  const DecodMainMenuView({super.key});

  @override
  State<DecodMainMenuView> createState() => DecodMainMenuViewState();
}

class DecodMainMenuViewState extends State<DecodMainMenuView> {
  late final Future<List<DecodTag>> tags;

  @override
  void initState(){
    super.initState();
    // This is to preload categories...
    // The rest of the loading is handled in
    // the TrainToDecod class...
    tags = fetchTags();
  }

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
            child: DecodedHistory(),
          ),
          Container(
            color: CupertinoColors.systemGrey6,
            width: double.infinity,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TrainToDecod(
                tags: tags
              )
            )
          )
        ]
      ),
    );
  }
}