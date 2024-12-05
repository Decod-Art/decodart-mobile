import 'package:decodart/model/hive/decod.dart' show GameData;
import 'package:decodart/controller_and_mixins/decod/menu_controller.dart' show MenuController;
import 'package:decodart/view/decod/menu/util/stats/_empty.dart' show EmptyStat;
import 'package:decodart/view/decod/menu/util/stats/_stat_content.dart' show StatContent;
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A widget that displays the statistics for the Decod feature.
/// 
/// The `StatsWidget` is a stateful widget that shows the user's game statistics.
/// It uses a `MenuController` to manage the data and a `ValueListenableBuilder` to update the UI when the data changes.
/// 
/// Attributes:
/// 
/// - `key` (optional): A [Key] to uniquely identify the widget.
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

  GameData get score => controller.score;
  bool get hasPlayed => score.hasPlayed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: controller.isNotOpened
        ? const Center(child: CupertinoActivityIndicator())
        : ValueListenableBuilder(
            // The ValueListenableBuilder should update the stats content as soon as the box gets updated
            valueListenable: controller.gameDataBox.listenable(),
            builder: (context, Box<GameData> box, _) => hasPlayed ? StatContent(score: controller.score, onReset: reset) : const EmptyStat()
          )
    );
  }
}