import 'package:decodart/api/artwork.dart' show fetchArtworkByImage;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:decodart/model/image.dart';
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/camera/util/camera/button.dart' show CameraButtonWidget;
import 'package:decodart/controller/camera/controller.dart' show DecodCameraController;
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
  late final DecodCameraController controller;
  
  // hide camera when it is obfuscated by switching to another view
  bool hideCamera=false;

  bool noResult = false;

  ArtworkListItem? artworkFound;

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

    controller = DecodCameraController(
      onInit: _cameraInitialized,
      onSearchStart: _onSearchStart,
      runSearch: fetchArtworkByImage,
      onSearchEnd: _onSearchEnd
    ); 
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

  Future<void> _onSearchStart() async {
    artworkFound = null;
    await _animationController.reverse();
    setState(() {});
  }

  void _onSearchEnd(List<ArtworkListItem> artworks) {
    _saveResults(artworks);
    _showResults(artworks);
  }

  void _showResults(List<ArtworkListItem> artworks) {
    setState(() {});
    if (artworks.length == 1) {
      artworkFound = artworks.first;
      _animationController.forward(); // this shows the small popup
    } else if (artworks.isNotEmpty){
      showWidgetInModal(
        context,
        (context) => ResultsView(results: artworks)
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
      await Future.wait(items.map((item) => (item.image as ImageOnline).downloadImageData()));
      recentList.insertAll(0, items.map((item)=> item.toHive()).toList());
      if (recentList.length > maxRecentSaved) recentList.removeRange(maxRecentSaved, recentList.length);
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
                        if (hideCamera)controller.dispose();
                      });
                    },
                    child: hideCamera
                      ? Container()
                      : CoreCamera(controller: controller)
                  )
                ),
              ),
              if (artworkFound != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Center(
                        child: ResultsWidget(
                          artwork: artworkFound!,
                          onPressed: () {
                            showWidgetInModal(
                              context,
                              (context) => FutureArtworkView(artwork: artworkFound!)
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
            onPressed: controller.takePicture
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