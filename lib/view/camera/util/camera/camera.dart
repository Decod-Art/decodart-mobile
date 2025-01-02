import 'package:decodart/api/artwork.dart' show fetchArtworkByImage;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:decodart/model/image.dart' show ImageOnline;
import 'package:decodart/util/logger.dart';
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/camera/util/camera/button.dart' show CameraButtonWidget;
import 'package:decodart/controller_and_mixins/camera/controller.dart' show DecodCameraController;
import 'package:decodart/view/camera/util/camera/core_camera.dart' show CoreCamera;
import 'package:decodart/view/camera/util/results/no_result.dart' show NoResultWidget;
import 'package:decodart/view/camera/util/results/result.dart' show ResultWidget;
import 'package:decodart/view/camera/util/results/results.dart' show ResultsView;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;
import 'package:visibility_detector/visibility_detector.dart' show VisibilityDetector, VisibilityInfo;
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A widget that provides a camera interface for scanning artworks and displaying results.
/// 
/// The `Camera` is a stateful widget that uses a camera to scan artworks and display the results.
/// It handles the camera initialization, scanning process, and displaying results in a modal or a small popup.
/// 
/// Attributes:
/// 
/// - `height` (optional): A [double] representing the height of the camera container. Defaults to [double.infinity].
class Camera extends StatefulWidget {
  final double height;//containerHeight
  const Camera({super.key, this.height=double.infinity});

  @override
  State<Camera> createState() => _CameraState();
}

final int maxRecentSaved = 10;

class _CameraState extends State<Camera> with SingleTickerProviderStateMixin{
  late final DecodCameraController controller;
  
  // hide camera when it is obfuscated by switching to another view
  bool hideCamera=false;

  bool noResult = false;

  ArtworkListItem? artworkFound;

  // Animation for the popup when a single result arrives
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  Box<List>? recentScanBox;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _offsetAnimation = Tween<Offset>(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
      .animate(CurvedAnimation(parent: _animationController,curve: Curves.easeInOut));

    controller = DecodCameraController(
      onInit: _cameraInitialized,
      onSearchStart: _resetSearch,
      runSearch: fetchArtworkByImage,
      onSearchEnd: _showResults
    ); 
  }

  // this this so that the camera button get updated with the fact
  // that the camera has been initialized (i.e. the button should become active)
  void _cameraInitialized() => setState(() {});

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _resetSearch() async {
    artworkFound = null;
    await _animationController.reverse();
    setState(() {});
  }

  void _showResults(List<ArtworkListItem> artworks) {
    // required
    // e.g. the button of the camera should refresh and stop
    // loading
    setState(() {});
    if (artworks.length == 1) {
      artworkFound = artworks.first;
      // this shows the small popup
      _animationController.forward();
    } else if (artworks.isNotEmpty){
      showWidgetInModal(context, (context) => ResultsView(results: artworks, onPressed: _saveResult,));
    } else {
      setState(() {noResult = true;});
    }
  }

  Future<void> _saveResult(ArtworkListItem item) async {
    logger.d("Saving artwork ${item.uid} to recently scanned");
    recentScanBox ??= await Hive.openBox<List>('recentScan');
    var recentList = recentScanBox?.get('recent', defaultValue: [])
                                  ?.cast<hive.ArtworkListItem>();
    if (recentList != null) {
      try {
        await (item.image as ImageOnline).downloadImageData();
        final hive.ArtworkListItem hiveItem = item.toHive();
        if (recentList.remove(hiveItem)) logger.d("Item previously scanned");
        recentList.insert(0, hiveItem);
        
        if (recentList.length > maxRecentSaved) {
          recentList = recentList.sublist(0, maxRecentSaved);
        }

        // This should trigger any listener over the value of the box
        recentScanBox?.put('recent', recentList);
      } catch (e) {
        logger.e(e);
      }

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
                      setState(() {hideCamera=info.visibleFraction == 0;});
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
                        child: ResultWidget(
                          artwork: artworkFound!,
                          onPressed: () {
                            // The artwork needs to be retrieved
                            // because resetSearch will set artworkFound to null
                            final artwork = artworkFound!;
                            _resetSearch();
                            // if the user clicks on the item, we suppose that it's been
                            // correctly identified... thus we save it
                            _saveResult(artwork);
                            showWidgetInModal(context, (context) => FutureArtworkView(artwork: artwork));
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
          // On pressed, the noResults get false
          // and the button of the camera shows again
          NoResultWidget(onPressed: () => setState(() {noResult=false;})),
      ],
    );
  }
}