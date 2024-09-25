import 'package:decodart/model/artwork_tag.dart' show ArtworkTag;
import 'package:decodart/model/decod.dart' show DecodTag;
import 'package:decodart/view/decod/game/manager.dart' show DecodView;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show AlertDialog, showDialog;

class TrainToDecod extends StatefulWidget {
  final Future<List<DecodTag>> tags;
  const TrainToDecod({super.key, required this.tags});
  
  @override
  State<StatefulWidget> createState() => _TrainToDecodState();

}

class _TrainToDecodState extends State<TrainToDecod> {
  final List<DecodTag> tags = [];

  @override
  void initState(){
    super.initState();
    _awaitTags();
  }  

  Future<void> _awaitTags() async {
    tags.addAll(await widget.tags);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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

class PopUpDialog extends StatefulWidget {
  final List<DecodTag> tags;
  const PopUpDialog({super.key, required this.tags});

  @override
  State<PopUpDialog> createState() => _PopUpDialogState();
}

class _PopUpDialogState extends State<PopUpDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  void _loadGame([DecodTag? tag]) {
    Navigator.of(
      context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DecodView(tag: tag),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text(
            //   "Choisissez une option",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 20),
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadGame();
              },
              child: const Text("Questions aléatoires"),
            ),
            for (final tag in widget.tags) ... [
              CupertinoButton(
                onPressed: () {
                   Navigator.of(context).pop();
                  _loadGame(tag);
                },
                child: Text(tag.name),
              ),
            ]
          ],
        ),
      ),
    );
  }
}