import 'package:decodart/view/camera/util/camera/controller.dart' as decod show DecodCameraController;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CoreCamera extends StatefulWidget {
  final decod.DecodCameraController controller;
  const CoreCamera({
    super.key,
    required this.controller
  });

  @override
  State<CoreCamera> createState() => CoreCameraState();
}

class CoreCameraState extends State<CoreCamera> {
  
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
    widget.controller.beforeSearchStart = _blink;
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
                    CameraPreview(widget.controller.cameraController),
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