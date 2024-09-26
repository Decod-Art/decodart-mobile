import 'package:decodart/view/camera/camera/button.dart';
import 'package:decodart/widgets/modal_or_fullscreen/page_scaffold.dart' show DecodPageScaffold;
import 'package:visibility_detector/visibility_detector.dart';
import 'package:decodart/view/camera/camera/core_camera.dart' show CoreCamera, CoreCameraState;
import 'package:decodart/view/camera/help.dart' show HelpView;
import 'package:decodart/view/camera/recent.dart' show RecentScan, RecentScanState;
import 'package:decodart/view/camera/results/no_result.dart';
import 'package:decodart/view/camera/results/results.dart' show ResultsView;
import 'package:flutter/cupertino.dart';
import 'package:decodart/api/artwork.dart' show fetchArtworkByImage;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/camera/results/result.dart' show ResultsWidget;
import 'package:decodart/widgets/modal_or_fullscreen/modal.dart' show ShowModal;
import 'package:decodart/widgets/new_decod_bar.dart' show NewDecodNavigationBar;


class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => CameraViewState();
}

class CameraViewState extends State<CameraView>  with ShowModal, SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isLoading = false;  

  final List<ArtworkListItem> results = [];
  bool noResult = false;
  bool hideCamera=false;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  final GlobalKey<CoreCameraState> cameraViewKey = GlobalKey<CoreCameraState>();
  final GlobalKey<RecentScanState> recentScanKey = GlobalKey<RecentScanState>();
  

  @override
  void initState() {
    super.initState();
    print('init');
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showResults() {
    setState(() {isLoading = false;});
    if (results.length == 1) {
      _animationController.forward();
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
    await _animationController.reverse();
    results.clear();
    isLoading = true;
    cameraViewKey.currentState?.takePicture();
    setState(() {});
  }

  

  void _runSearch(String imagePath) async {
    // await Future.delayed(const Duration(seconds: 2));
    var artworks = await fetchArtworkByImage(imagePath);
    results.addAll(artworks);
    recentScanKey.currentState!.addScan(artworks);
    _showResults();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 4 / 7;
    return DecodPageScaffold(
      title: "Scanner",
      smallTitle: true,
      leadingBar: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          showDecodModalBottomSheet(
            context,
            (context) => const HelpView(),
            expand: true,
            useRootNavigator: true);
        },
        child: const Icon(CupertinoIcons.info_circle, size: 24),
      ),
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
                  child: VisibilityDetector(
                    key: const Key('camera-view-key'),
                    onVisibilityChanged: (VisibilityInfo info){
                      setState(() {hideCamera=info.visibleFraction == 0;});
                    },
                    child: hideCamera?Container():CoreCamera(
                      key: cameraViewKey,
                      onImageTaken: _runSearch,
                    )
                  )
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
                          artwork: results[0],
                          onPressed: () {
                            showDecodModalBottomSheet(
                              context,
                              (context) => FutureArtworkView(artwork: results[0]),
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
            onPressed: _startSearch,)
        else
          NoResultWidget(onPressed: (){
            setState(() {
              noResult=false;
            });
          }),
        RecentScan(key: recentScanKey)
      ],
    );
    return CupertinoPageScaffold(
      navigationBar: NewDecodNavigationBar(
        leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          showDecodModalBottomSheet(
            context,
            (context) => const HelpView(),
            expand: true,
            useRootNavigator: true);
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
                        child: VisibilityDetector(
                          key: const Key('camera-view-key'),
                          onVisibilityChanged: (VisibilityInfo info){
                            setState(() {hideCamera=info.visibleFraction == 0;});
                          },
                          child: hideCamera?Container():CoreCamera(
                            key: cameraViewKey,
                            onImageTaken: _runSearch,
                          )
                        )
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
                                artwork: results[0],
                                onPressed: () {
                                  showDecodModalBottomSheet(
                                    context,
                                    (context) => FutureArtworkView(artwork: results[0]),
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
                  onPressed: _startSearch,)
              else
                NoResultWidget(onPressed: (){
                  setState(() {
                    noResult=false;
                  });
                }),
              RecentScan(key: recentScanKey)
            ],
          )
        )
      )
    );
  }
}