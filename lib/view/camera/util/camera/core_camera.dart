import 'package:decodart/view/camera/util/camera/controller.dart' as decod show CameraController;
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

class CoreCamera extends StatefulWidget {
  final void Function(String) onImageTaken;
  final decod.CameraController controller;
  const CoreCamera({
    super.key,
    required this.onImageTaken,
    required this.controller
  });

  @override
  State<CoreCamera> createState() => CoreCameraState();
}

class CoreCameraState extends State<CoreCamera> {
  CameraController? _cameraController;

  double _opacity = 0; // the blink when taking the picture

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _blink() async {
    setState(() {
      _opacity = 1.0;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 0.0;
      });
    });
  }

  Future<void> _initializeCamera() async {
    try {
      widget.controller.takePictureFunction = _takePicture;
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
          widget.controller.errorMessage = 'Permission refusée. Veuillez autoriser l\'accès à la caméra.';
        });
      } else if (status == PermissionStatus.permanentlyDenied) {
        setState(() {
         widget.controller.errorMessage = 'Permission refusée de façon permanente. Veuillez autoriser l\'accès à la caméra dans les paramètres.';
        });
      }
      widget.controller.isLoaded = true;
    } catch (e) {
      setState(() {
        widget.controller.errorMessage = 'Erreur lors de l\'initialisation de la caméra';
      });
    }
  }

  Future<void> _takePicture() async {
    if (widget.controller.canTakePicture){
      _blink();
      final image = await _cameraController!.takePicture();
      widget.onImageTaken(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.hasError
      ? Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Text(widget.controller.errorMessage!)
        )
      )
      : ! widget.controller.canTakePicture
        ? const Center(child: CupertinoActivityIndicator())
        : OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width*_cameraController!.value.aspectRatio,
                child: Stack(
                  children: [
                    CameraPreview(_cameraController!),
                    AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        color: CupertinoColors.black,
                      ),
                    ),
                  ]
                )
              ),
            )
        );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}