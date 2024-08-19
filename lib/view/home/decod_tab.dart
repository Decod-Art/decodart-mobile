import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:decodart/view/decod/manager.dart' show DecodManagerWidget;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class DecodTab extends StatefulWidget {
  const DecodTab({super.key});

  @override
  State<DecodTab> createState() => _DecodTabState();
}

class _DecodTabState extends State<DecodTab> {
  int? _score;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  @override
  void didUpdateWidget(covariant DecodTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadScore();
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = prefs.getInt('score') ?? 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Décoder'),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  'Votre score : ${_score??0}', 
                  style: const TextStyle(color: CupertinoColors.white, fontSize: 30)),
              )
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(
                    context, rootNavigator: true).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const DecodManagerWidget(),
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
                },
                child: 
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(
                      child: Text(
                        "Lancer une partie",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                )
              )
            )
          ]
        ),
      )
    );
  }
}