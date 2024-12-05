import 'package:decodart/model/decod.dart' show DecodTag;
import 'package:decodart/view/decod/game/manager.dart' show DecodManager;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show AlertDialog;


/// A widget that displays a popup dialog for selecting a game mode or category.
/// 
/// The `PopUpDialog` is a stateful widget that shows a dialog with options to start a game with random questions or select a specific category.
/// It uses an animation to scale the dialog when it appears.
/// 
/// Attributes:
/// 
/// - `tags` (required): A [List] of [DecodTag] objects representing the available categories.
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  void _loadGame([DecodTag? tag]) {
    Navigator.of(
      context, rootNavigator: true).push(
      PageRouteBuilder(
        // DecodManager is the class responsible for handling games
        pageBuilder: (context, animation, secondaryAnimation) => DecodManager(tag: tag),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
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
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadGame();
              },
              child: const Text("Questions aléatoires", textAlign: TextAlign.center),
            ),
            for (final tag in widget.tags) ... [
              CupertinoButton(
                onPressed: () {
                   Navigator.of(context).pop();
                  _loadGame(tag);
                },
                child: Text(tag.name, textAlign: TextAlign.center),
              ),
            ]
          ],
        ),
      ),
    );
  }
}