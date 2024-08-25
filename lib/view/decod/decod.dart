import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:decodart/view/decod/manager.dart' show DecodView;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class DecodMainMenuView extends StatefulWidget {
  const DecodMainMenuView({super.key});

  @override
  State<DecodMainMenuView> createState() => DecodMainMenuViewState();
}

class DecodMainMenuViewState extends State<DecodMainMenuView> {
  double? _success;
  double? _count;
  double? _rate;

  @override
  void initState() {
    super.initState();
    loadScore();
  }

  @override
  void didUpdateWidget(covariant DecodMainMenuView oldWidget) {
    loadScore();
    super.didUpdateWidget(oldWidget);    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadScore();
  }

  @override
  void reassemble() {
    super.reassemble();
    loadScore();
  }

  Future<void> loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _success = prefs.getDouble('success') ?? 0.0;
      _count = prefs.getDouble('count') ?? 0.0;
      if (_count != 0) {
        _rate = _success! * 100 / _count!;
      }
    });
  }

  Widget _statsBlock(BuildContext context) {
  if (_count == null || _count == 0) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: const Center(
        child: Text(
          "Décodez pour apprendre à mieux reconnaître les symboles dans l'art 🕵️",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
  // Retourner un autre widget ou rien si _count n'est pas égal à 0
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: CupertinoColors.systemGrey6,
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Taux de réussite', style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey2)),
        Text('${_rate!.toStringAsFixed(2)} %', style: const TextStyle(fontSize: 55)),
        const Text(
          "Continuez de Décoder afin d'apprendre à mieux reconnaître les symboles dans l'art 🕵️",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ]
    )
  );
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20),
                child: _statsBlock(context)
              )
            ),
            Expanded(
              flex: 3,
              child: Container()
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(
                    context, rootNavigator: true).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const DecodView(),
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: 75,
                        margin: const EdgeInsets.all(8.0),
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
                )
              )
            )
          ]
        ),
      )
    );
  }
}