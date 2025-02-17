import 'package:camera/camera.dart' show CameraController, ResolutionPreset, XFile, availableCameras;
import 'package:decodart/data/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/util/logger.dart' show logger;
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart' show Permission, PermissionActions, PermissionStatus;


class DecodCameraException implements Exception {
  final String message;

  DecodCameraException(this.message);

  @override
  String toString() => 'DecodCameraException: $message';
}

typedef RunSearch=Future<List<ArtworkListItem>>Function(String);
typedef AfterPictureTaken = void Function(String);
typedef OnSearchStart = VoidCallback;
typedef OnSearchResults=void Function(List<ArtworkListItem>);
typedef FutureVoidCallback=Future<void>Function();

/// ViewModel for managing the camera and search functionality.
class CameraViewModel {
  String? errorMessage;

  bool _isLoaded=false;
  bool _isSearching=false;

  final VoidCallback? onInit;

  // These are user functions to execute at steps during
  //  the image search procedure
  FutureVoidCallback? _beforeSearch;
  AfterPictureTaken? _onSearch;
  VoidCallback? _afterSearch;

  // This are the user functions to specify
  // that actually perform the search

  // take the picture
  final OnSearchStart? onSearchStart;
  // run the search
  final RunSearch? runSearch;
  // returns the results
  final OnSearchResults? onSearchEnd;

  
  CameraController? _cameraController;

  CameraViewModel({
    this.errorMessage,
    this.onInit,
    this.onSearchStart,
    this.runSearch,
    this.onSearchEnd
  });

  set beforeSearch (FutureVoidCallback? fct) {
    _beforeSearch = fct;
  }

  set onSearch (void Function(String)? fct) {
    _onSearch = fct;
  }

  set afterSearch(VoidCallback? fct) {
    _afterSearch = fct;
  }

  bool get canTakePicture => errorMessage == null && isLoaded;

  bool get hasError => errorMessage != null;

  bool get isSearching => _isSearching;

  /// Takes a picture and performs the search.
  ///
  /// Throws a [DecodCameraException] if the camera is not initialized.
  Future<void> takePicture() async {
    if (canTakePicture){
      _isSearching = true;

      onSearchStart?.call();
      
      await Future.wait([
        _beforeSearch?.call() ?? Future.value(),
        _cameraController!.takePicture()
      ]).then((res) async {
        final image = res[1] as XFile; // Récupérez l'image de la caméra
        _onSearch?.call(image.path);
        List<ArtworkListItem>? results;
        try {
          results = await runSearch!(image.path);
        } catch(e) {
          logger.e("Search failed : $e");
        } finally {
          results ??= [];
        }

        _isSearching = false;

        _afterSearch?.call();
        onSearchEnd?.call(results);
      });
      
    } else {
      throw DecodCameraException('Camera can\'t take pictures for now. Init first.');
    }
  }

  bool get isLoaded => _isLoaded&&_cameraController!=null;
  
  set isLoaded(bool isLoaded) {
    _isLoaded = isLoaded;
    if(_isLoaded)onInit?.call();
  }

  /// Initializes the camera.
  ///
  /// Requests camera permissions and initializes the camera controller.
  /// Sets an error message if the initialization fails.
  Future<void> init() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      final status = await Permission.camera.request();
      if (status == PermissionStatus.granted) {
        _cameraController = CameraController(
          firstCamera,
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
      } else if (status == PermissionStatus.denied) {
        errorMessage = 'Permission refusée. Veuillez autoriser l\'accès à la caméra.';
      } else if (status == PermissionStatus.permanentlyDenied) {
        
        errorMessage = 'Permission refusée de façon permanente. Veuillez autoriser l\'accès à la caméra dans les paramètres.';
      } else {
        errorMessage = 'Erreur inconnue';
      }
    } catch (e) {
        errorMessage = 'Erreur lors de l\'initialisation de la caméra';
    }
    isLoaded = true;
  }

  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;
    isLoaded = false;
  }

  CameraController get cameraController {
    return _cameraController!;
  }

  double get aspectRatio => _cameraController!.value.aspectRatio;
}