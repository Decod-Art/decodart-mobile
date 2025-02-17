import 'package:decodart/data/api/decod.dart' show fetchTags;
import 'package:decodart/data/model/decod.dart' show DecodTag;
import 'package:decodart/ui/decod/widgets/menu/util/train_to_decod/_popup.dart' show PopUpDialog;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show showDialog;

/// A widget that provides a button to train for decoding.
/// 
/// The `TrainToDecod` is a stateful widget that displays a button. When the button is pressed, it shows a popup dialog with options to start a game with random questions or select a specific category.
/// It fetches the available categories (tags) asynchronously and retries fetching up to a specified number of times if it fails.
/// After each failed attempt it waits a few seconds before the retry
/// 
/// Attributes:
/// 
/// - `key` (optional): A [Key] to uniquely identify the widget.
class TrainToDecod extends StatefulWidget {
  const TrainToDecod({super.key});
  
  @override
  State<StatefulWidget> createState() => _TrainToDecodState();

}

final int nbRetries = 5;

class _TrainToDecodState extends State<TrainToDecod> {
  final List<DecodTag> tags = [];

  @override
  void initState(){
    super.initState();
    _awaitTags();
  }  

/// Fetches the available categories (tags) asynchronously and retries fetching up to a specified number of times if it fails.
/// After each failed attempt, it waits a few seconds before retrying.
/// 
/// Parameters:
/// 
/// - `tryNumber` (optional): An [int] representing the current retry attempt. Defaults to 0.
Future<void> _awaitTags([int tryNumber = 0]) async {
  if (tryNumber == nbRetries) return;
  Future<List<DecodTag>> futureTags = fetchTags();
  try {
    if (tags.isEmpty) {
      // Only add new tags if previous attempts failed to load them
      tags.addAll(await futureTags);
      setState(() {});
    }
  } catch (_) {
    // Wait for a few seconds before retrying
    await Future.delayed(Duration(seconds: 1 << (tryNumber + 2)));
    _awaitTags(tryNumber + 1);
  }
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(context: context, builder: (BuildContext context) => PopUpDialog(tags: tags)),
      child: Column(
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(color: CupertinoColors.activeBlue, borderRadius: BorderRadius.circular(8.0)),
            child: const Center(
              child: Text("S'entraîner à décoder", style: TextStyle(color: CupertinoColors.white),
              ),
            ),
          ),
        ]
      )
    );
  }
}

