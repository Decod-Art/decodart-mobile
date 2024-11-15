import 'package:decodart/model/hive/decod.dart' show GameData;
import 'package:decodart/controller/decod/menu_controller.dart' show MenuController;
import 'package:decodart/view/decod/menu/util/stats/_empty.dart' show EmptyStat;
import 'package:decodart/view/decod/menu/util/stats/_stat_content.dart' show StatContent;
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key});

  @override
  State<StatsWidget> createState() => StatsWidgetState();
}

class StatsWidgetState extends State<StatsWidget> {
  final MenuController controller = MenuController();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _openBox() async {
    await controller.openBoxes();
    setState(() {});
  }

  Future<void> reset() async {
    await controller.reset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: controller.isNotOpened
        ? const Center(child: CupertinoActivityIndicator())
        : ValueListenableBuilder(
            valueListenable: controller.gameDataBox.listenable(),
            builder: (context, Box<GameData> box, _) {
              final GameData score = controller.score;
              if (score.hasPlayed) {
                return StatContent(
                  score: score,
                  onReset: reset
                );
              } else {
                return const EmptyStat();
              }
            }
          )
    );
  }
}