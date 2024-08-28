import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

class CoreCamera extends StatefulWidget {
  final void Function(String) onImageTaken;
  const CoreCamera({
    super.key,
    required this.onImageTaken
  });

  @override
  State<CoreCamera> createState() => CoreCameraState();
}

class CoreCameraState extends State<CoreCamera> {
  CameraController? _cameraController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
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
        setState(() {});
      } else if (status == PermissionStatus.denied) {
        setState(() {
          _errorMessage = 'Permission refusée. Veuillez autoriser l\'accès à la caméra.';
        });
      } else if (status == PermissionStatus.permanentlyDenied) {
        setState(() {
          _errorMessage = 'Permission refusée de façon permanente. Veuillez autoriser l\'accès à la caméra dans les paramètres.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de l\'initialisation de la caméra';
      });
    }
  }

  void takePicture() async {
    final image = await _cameraController!.takePicture();
    widget.onImageTaken(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return _errorMessage != null
      ? Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Text(_errorMessage!)
        )
      )
      : _cameraController == null
        ? const Center(child: CupertinoActivityIndicator())
        : OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(_cameraController!),
              )
            )
        );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}