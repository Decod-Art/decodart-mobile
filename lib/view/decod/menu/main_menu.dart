import 'package:decodart/api/decod.dart' show fetchTags;
import 'package:decodart/model/decod.dart' show DecodTag;
import 'package:decodart/view/decod/menu/history.dart' show DecodedHistory, DecodedHistoryState;
import 'package:decodart/view/decod/menu/stats.dart' show StatsWidget, StatsWidgetState;
import 'package:decodart/view/decod/menu/train_to_decod.dart' show TrainToDecod;
import 'package:decodart/widgets/modal_or_fullscreen/modal.dart' show ShowModal;
import 'package:decodart/widgets/modal_or_fullscreen/page_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class DecodMainMenuView extends StatefulWidget {
  const DecodMainMenuView({super.key});

  @override
  State<DecodMainMenuView> createState() => DecodMainMenuViewState();
}

class DecodMainMenuViewState extends State<DecodMainMenuView> with ShowModal {
  final GlobalKey<DecodedHistoryState> decodedHistoryKey = GlobalKey<DecodedHistoryState>();
  final GlobalKey<StatsWidgetState> statsWidgetKey = GlobalKey<StatsWidgetState>();
  late final Future<List<DecodTag>> tags;

  @override
  void initState(){
    super.initState();
    tags = fetchTags();
  }

  Future<void> reset() async {
    await statsWidgetKey.currentState?.reset();
    await decodedHistoryKey.currentState?.reset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'Décoder',
      smallTitle: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatsWidget(key: statsWidgetKey, onReset: reset,),
          Expanded(
            flex: 3,
            child: DecodedHistory(key: decodedHistoryKey),
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