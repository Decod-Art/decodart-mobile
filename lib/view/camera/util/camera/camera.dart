import 'package:decodart/api/artwork.dart' show fetchArtworkByImage;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/camera/util/camera/button.dart' show CameraButtonWidget;
import 'package:decodart/view/camera/util/camera/controller.dart' show CameraController;
import 'package:decodart/view/camera/util/camera/core_camera.dart' show CoreCamera;
import 'package:decodart/view/camera/util/results/no_result.dart' show NoResultWidget;
import 'package:decodart/view/camera/util/results/result.dart' show ResultsWidget;
import 'package:decodart/view/camera/util/results/results.dart' show ResultsView;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;
import 'package:visibility_detector/visibility_detector.dart' show VisibilityDetector, VisibilityInfo;
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Camera extends StatefulWidget {
  final double height;//containerHeight
  const Camera({super.key, this.height=double.infinity});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with SingleTickerProviderStateMixin{
  late final CameraController controller;
  
  // hide camera when it is obfuscated by switching to another view
  bool hideCamera=false;

  final List<ArtworkListItem> results = [];
  bool noResult = false;

  // Animation for the popup when a single result arrives
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  static const int maxRecentSaved = 10;
  Box<List>? recentScanBox;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _offsetAnimation = Tween<Offset>(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
      .animate(CurvedAnimation(parent: _animationController,curve: Curves.easeInOut));

    controller = CameraController(initializedCallback: _cameraInitialized);
  }

  void _cameraInitialized() {
    // this this so that the camera button get updated with the fact
    // that the camera has been initialized (i.e. the button should become active)
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startSearch() async {
    // reset the previous results
    noResult = false;
    await _animationController.reverse();
    results.clear();

    // start search
    if (controller.canTakePicture) {
      setState(() {
        controller.isSearching = true;
      });
      controller.takePicture();
    }
  }

  Future<void> _runSearch(String imagePath) async {
    var artworks = await fetchArtworkByImage(imagePath);
    results.addAll(artworks);
    _showResults();
    await _saveResults(artworks);
  }

  void _showResults() {
    setState(() {controller.isSearching = false;});
    if (results.length == 1) {
      _animationController.forward(); // this shows the small popup
    } else if (results.isNotEmpty){
      showWidgetInModal(
        context,
        (context) => ResultsView(results: results)
      );
    } else {
      setState(() {
        noResult = true;
      });
    }
  }

  Future<void> _saveResults(List<ArtworkListItem> items) async {
    // saving up to maxRecentSaved elements in the hive box
    recentScanBox ??= await Hive.openBox<List>('recentScan');
    var recentList = recentScanBox?.get('recent', defaultValue: [])
                                  ?.cast<hive.ArtworkListItem>();
    if (recentList != null) {
      recentList..insertAll(0, items.map((item)=> item.toHive())
                                   .toList())
                ..removeRange(maxRecentSaved, recentList.length);
      recentScanBox?.put('recent', recentList);
    }
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: VisibilityDetector(
                    key: const Key('camera-view-key'),
                    onVisibilityChanged: (VisibilityInfo info){
                      setState(() {
                        hideCamera=info.visibleFraction == 0;
                        controller.isLoaded = !hideCamera;
                      });
                    },
                    child: hideCamera
                      ? Container()
                      : CoreCamera(
                          onImageTaken: _runSearch,
                          controller: controller,
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
                            showWidgetInModal(
                              context,
                              (context) => FutureArtworkView(artwork: results[0])
                            );
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
            canTakePicture: controller.canTakePicture,
            isSearching: controller.isSearching,
            onPressed: _startSearch
          )
        else
          NoResultWidget(onPressed: (){
            setState(() {
              noResult=false;
            });
          }),
      ],
    );
  }
}