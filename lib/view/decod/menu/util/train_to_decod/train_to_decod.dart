import 'package:decodart/api/decod.dart' show fetchTags;
import 'package:decodart/model/decod.dart' show DecodTag;
import 'package:decodart/view/decod/menu/util/train_to_decod/_popup.dart' show PopUpDialog;
import 'package:flutter/cupertino.dart';
import 'package:mutex/mutex.dart' show Mutex;
import 'package:flutter/material.dart' show showDialog;

class TrainToDecod extends StatefulWidget {
  final Future<List<DecodTag>> tags;
  const TrainToDecod({super.key, required this.tags});
  
  @override
  State<StatefulWidget> createState() => _TrainToDecodState();

}

class _TrainToDecodState extends State<TrainToDecod> {
  final List<DecodTag> tags = [];
  final Mutex mutex = Mutex();

  @override
  void initState(){
    super.initState();
    _awaitTags(widget.tags);
  }  

  Future<void> _awaitTags(Future<List<DecodTag>> tags) async {
    await mutex.acquire();
    try{
      if (this.tags.isEmpty) {
        // only add new tags if previous failed to load...
        this.tags.addAll(await tags);
      }
    } finally {
      mutex.release();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (tags.isEmpty) _awaitTags(fetchTags());
          
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopUpDialog(tags: tags);
          },
        ); 
      },
      child: Column(
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Center(
              child: Text(
                "S'entraîner à décoder",
                style: TextStyle(color: CupertinoColors.white),
              ),
            ),
          ),
        ]
      )
    );
  }
}

