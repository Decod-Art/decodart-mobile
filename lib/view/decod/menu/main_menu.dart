import 'package:decodart/view/decod/menu/history.dart' show DecodedHistory, DecodedHistoryState;
import 'package:decodart/view/decod/menu/stats.dart' show StatsWidget, StatsWidgetState;
import 'package:decodart/widgets/modal/modal.dart' show ShowModal;
import 'package:decodart/widgets/new_decod_bar.dart';
import 'package:flutter/cupertino.dart';

import 'package:decodart/view/decod/game/manager.dart' show DecodView;

class DecodMainMenuView extends StatefulWidget {
  const DecodMainMenuView({super.key});

  @override
  State<DecodMainMenuView> createState() => DecodMainMenuViewState();
}

class DecodMainMenuViewState extends State<DecodMainMenuView> with ShowModal {
  final GlobalKey<DecodedHistoryState> decodedHistoryKey = GlobalKey<DecodedHistoryState>();
  final GlobalKey<StatsWidgetState> statsWidgetKey = GlobalKey<StatsWidgetState>();

  

  Future<void> reset() async {
    await statsWidgetKey.currentState?.reset();
    await decodedHistoryKey.currentState?.reset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const NewDecodNavigationBar(
        title: "Décoder"
      ),
      child: SafeArea(
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
                )
              )
            )
          ]
        ),
      )
    );
  }
}