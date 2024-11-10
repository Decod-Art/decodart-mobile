import 'package:camera/camera.dart' show CameraController, ResolutionPreset, availableCameras;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart' show Permission, PermissionActions, PermissionStatus;


class DecodCameraException implements Exception {
  final String message;

  DecodCameraException(this.message);

  @override
  String toString() => 'DecodCameraException: $message';
}

typedef SearchFct=Future<List<ArtworkListItem>>Function(String);
typedef SearchEndFct=void Function(List<ArtworkListItem>);

class DecodCameraController {
  String? errorMessage;

  bool _isLoaded=false;
  bool _isSearching=false;

  final VoidCallback? onInit;

  VoidCallback? _beforeSearchStart;
  final VoidCallback? onSearchStart;
  final SearchFct? runSearch;
  final SearchEndFct? onSearchEnd;

  
  CameraController? _cameraController;

  DecodCameraController({
    this.errorMessage,
    this.onInit,
    this.onSearchStart,
    this.runSearch,
    this.onSearchEnd
  });

  set beforeSearchStart (VoidCallback? fct) {
    _beforeSearchStart = fct;
  }

  bool get canTakePicture => errorMessage == null&&isLoaded;

  bool get hasError => errorMessage != null;

  bool get isSearching => _isSearching;

  Future<void> takePicture() async {
    if (canTakePicture){
      _isSearching = true;

      _beforeSearchStart?.call();
      onSearchStart?.call();

      final image = await _cameraController!.takePicture();
      final results = await runSearch?.call(image.path)??const[];

      _isSearching = false;

      onSearchEnd?.call(results);

    } else {
      throw DecodCameraException('Camera can\'t take pictures for now.');
    }
  }

  bool get isLoaded => _isLoaded&&_cameraController!=null;
  
  set isLoaded(bool isLoaded) {
    _isLoaded = isLoaded;
    if(_isLoaded)onInit?.call();
  }

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