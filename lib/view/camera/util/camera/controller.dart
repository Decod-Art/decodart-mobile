import 'package:flutter/cupertino.dart';

class CameraController {
  String? errorMessage;
  bool _isLoaded=false;
  VoidCallback? _takePicture;
  bool isSearching=false;
  VoidCallback? initializedCallback;
  CameraController({this.errorMessage, VoidCallback? takePicture, this.initializedCallback}): _takePicture=takePicture;

  bool get canTakePicture => errorMessage == null&&isLoaded;

  bool get hasError => errorMessage != null;

  void takePicture() {
    if (canTakePicture){
      _takePicture?.call();
    }
  }

  bool get isLoaded => _isLoaded;
  set isLoaded(bool isLoaded) {
    _isLoaded = isLoaded;
    initializedCallback?.call();
  }

  set takePictureFunction(VoidCallback fct) {
    _takePicture = fct;
  }
}