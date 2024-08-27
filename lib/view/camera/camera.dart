import 'dart:async';
import 'package:decodart/view/camera/button.dart';
import 'package:decodart/view/camera/no_result.dart';
import 'package:decodart/view/camera/results.dart' show ResultsView;
import 'package:flutter/cupertino.dart';
import 'package:decodart/api/artwork.dart' show fetchAllArtworks, fetchArtworkById;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/camera/result.dart' show ResultsWidget;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/modal/modal.dart' show ShowModal;
import 'package:decodart/widgets/new_decod_bar.dart' show NewDecodNavigationBar; // Assurez-vous d'importer votre NewDecodNavigationBar

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>  with ShowModal, SingleTickerProviderStateMixin {
  bool isLoading = false;
  final List<ArtworkListItem> recent = [];

  final List<ArtworkListItem> results = [];
  bool noResult = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _fetchRecent();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchRecent() async {
    recent.addAll(await fetchAllArtworks());
    setState(() {});
  }

  void _search() async {
    _startSearch();
    await Future.delayed(const Duration(seconds: 2));
    results.add(recent[0]);
    results.add(recent[1]);
    // TODO Append to recent as well top10 ?
    _showResults();
  }

  void _showResults() {
    setState(() {isLoading = false;});
    if (results.length == 1) {
      _controller.forward();
    } else if (results.isNotEmpty){
      showDecodModalBottomSheet(
        context,
        (context) => ResultsView(results: results),
        expand: true,
        useRootNavigator: true);
    } else {
      noResult = true;
    }
  }

  void _startSearch() async {
    noResult = false;
    await _controller.reverse();
    results.clear();
    isLoading = true;
    setState(() {});
  }

  // Future<String> _sendPicture(BuildContext context, String imagePath) async {
  //   // await Future.delayed(const Duration(seconds: 2));
  //   var artworks = await fetchArtworkByImage(imagePath);
    
  //   if (context.mounted && artworks.isNotEmpty) {
  //     Navigator.of(context).pushReplacement(
  //       CupertinoPageRoute(builder: (BuildContext context) {
  //         return ListWidget(
  //           listName: 'Résultats',
  //           listContent: artworks,
  //           onClick: (AbstractListItem item) => ArtworkDetailsWidget(artworkId: item.uid!),
  //         );
  //       }),
  //     );
  //   }
  //   return 'Artwork not found';
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 2 / 3;
    return CupertinoPageScaffold(
      navigationBar: NewDecodNavigationBar(
        leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          // Ajoutez ici la logique pour ce qui doit se passer lorsque l'icône est cliquée
        },
        child: const Icon(CupertinoIcons.info_circle, size: 24),
      ),
        title: 'Scanner',
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: containerHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Leonardo_da_vinci%2C_la_gioconda%2C_1503-06_circa.jpg/1280px-Leonardo_da_vinci%2C_la_gioconda%2C_1503-06_circa.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (results.length==1)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRect(
                          child: SlideTransition(
                            position: _offsetAnimation,
                            child: Center(
                              child: ResultsWidget(
                                artwork: recent[0],
                                onPressed: () {
                                  final futureArtwork = fetchArtworkById(recent[0].uid!);
                                  showDecodModalBottomSheet(
                                    context,
                                    (context) => FutureArtworkView(artwork: futureArtwork),
                                    expand: true,
                                    useRootNavigator: true);
                                },
                              ),
                            ),
                          ),
                        )
                      ),
                  ]
                )
              ),
              const SizedBox(height: 20),
              if (!noResult)
                CameraButtonWidget(
                  isLoading: isLoading,
                  onPressed: _search,)
              else
                NoResultWidget(onPressed: (){
                  setState(() {
                    noResult=false;
                  });
                }),
              if (recent.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(top: 45, bottom: 15),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Scans récents',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500)),
                        ),
                      ListWithThumbnail(items: recent, onPress: (item) async {
                        final futureArtwork = fetchArtworkById(item.uid!);
                        showDecodModalBottomSheet(
                          context,
                          (context) => FutureArtworkView(artwork: futureArtwork),
                          expand: true,
                          useRootNavigator: true);
                      },)
                    ]
                  )
                )
            ],
          )
        )
      )
    );
  }
}