import 'dart:io' show File;

import 'package:decodart/ui/camera/view_model/view_model.dart' show CameraViewModel;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

/// A widget that provides the core camera functionality for capturing images.
/// 
/// The `CoreCamera` is a stateful widget that initializes the camera, handles the image capture process, and displays the camera preview.
/// It also manages the display of a preview image and a blink effect when a picture is taken.
/// 
/// Attributes:
/// 
/// - `controller` (required): A [CameraViewModel] that manages the camera operations.
class CoreCamera extends StatefulWidget {
  final CameraViewModel controller;
  const CoreCamera({
    super.key,
    required this.controller
  });

  @override
  State<CoreCamera> createState() => CoreCameraState();
}

class CoreCameraState extends State<CoreCamera> {
  // The frozen image that will show when the image is taken
  Image? preview;
  
  double _opacity = 0; // the blink when taking the picture

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _fadeIn () async {
    setState(() {
      _opacity = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _fadeOutAndPreview (String path) async {
    setState(() {
      preview = Image.file(File(path));
      _opacity = 0.0;
    });
  }

  Future<void> _resetPreview () async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {preview=null;});
  }

  Future<void> _initializeCamera() async {
    widget.controller.beforeSearch = _fadeIn;
    widget.controller.onSearch = _fadeOutAndPreview;
    widget.controller.afterSearch = _resetPreview;
    await widget.controller.init();
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical = MediaQuery.of(context).orientation == Orientation.portrait;
    double aspectRatio = widget.controller.isLoaded
      ? widget.controller.aspectRatio
      : 1;

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
                height: MediaQuery.of(context).size.width*(isVertical?aspectRatio:1/aspectRatio),
                child: Stack(
                  children: [
                    preview ?? CameraPreview(widget.controller.cameraController),
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
    widget.controller.dispose();
    super.dispose();
  }
}