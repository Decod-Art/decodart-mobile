import 'package:decodart/api/artwork.dart' show fetchAllArtworks, fetchArtworkById;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/modal/modal.dart' show ShowModal;
import 'package:decodart/widgets/new_decod_bar.dart';
import 'package:flutter/cupertino.dart';

import 'package:decodart/view/decod/manager.dart' show DecodView;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class DecodMainMenuView extends StatefulWidget {
  const DecodMainMenuView({super.key});

  @override
  State<DecodMainMenuView> createState() => DecodMainMenuViewState();
}

class DecodMainMenuViewState extends State<DecodMainMenuView> with ShowModal {
  double? _rate;
  final List<ArtworkListItem> decoded = [];

  @override
  void initState() {
    super.initState();
    loadScore();
    _fetchDecoded();
  }

  void _fetchDecoded() async {
    decoded.addAll(await fetchAllArtworks());
    setState(() {});
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
      double success = prefs.getDouble('success') ?? 0.0;
      double count = prefs.getDouble('count') ?? 0.0;
      if (count != 0) {
        _rate = success * 100 / count;
      }
    });
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('success');
    prefs.remove('count');
    _rate = null;
    setState(() {});
  }

  Widget _statsBlock(BuildContext context) {
  if (_rate == null) {
    return Container(
      width: double.infinity,
      height: 200,
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
    height: 200,
    //padding: const EdgeInsets.all(16.0),
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
        CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          await reset();
        },
        child: const Text(
          'Réinitialiser',
          style: TextStyle(
            fontSize: 16,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
      ]
    )
  );
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
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20),
              child: _statsBlock(context)
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: decoded.isEmpty?Container():Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 15),
                      child: Text(
                        'Œuvres décodées',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                      ),
                    ListWithThumbnail(items: decoded, onPress: (item) async {
                      final futureArtwork = fetchArtworkById(item.uid!);
                      showDecodModalBottomSheet(
                        context,
                        (context) => FutureArtworkView(artwork: futureArtwork),
                        expand: true,
                        useRootNavigator: true);
                    },)
                  ],
                )
              )
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