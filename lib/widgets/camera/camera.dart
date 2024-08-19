import 'dart:async';
import 'package:flutter/material.dart' show Colors, CircularProgressIndicator;
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraWidget extends StatefulWidget {

  final Future<String> Function(String) onPictureTaken;
  
  const CameraWidget({super.key, required this.onPictureTaken});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String _errorMessage = '';
  String _resultMessage = '';
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try{
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      final status = await Permission.camera.request();
      if (status == PermissionStatus.granted) {
        _controller = CameraController(
          firstCamera,
          ResolutionPreset.high,
        );
        _initializeControllerFuture = _controller!.initialize().then((_) {
          // Démarrez le Timer une fois que la caméra est initialisée
         // _startTakingPictures();
        });
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
      setState((){
        _errorMessage = 'Erreur lors de l\'initialisation de la caméra';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _waiting(BuildContext context){
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: CupertinoColors.black,
        child: const Center(child: CircularProgressIndicator())
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)));
    }

    if (_controller == null || submitting) {
      return _waiting(context);
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              CameraPreview(_controller!),
              if (_resultMessage != '')
                Positioned(
                  left: 0,
                  right: 0,
                  top: 50,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    height: 100,
                    child: Center(child: Text(
                      _resultMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  height: 130,
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            onPressed: () {
                              // Action pour le bouton "Annuler"
                              Navigator.of(context).pop();
                            },
                            child: const Text("Annuler", style: TextStyle(color: Colors.white)),
                          ),
                        ]
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: CupertinoButton(
                            onPressed: () async {
                              try {
                                final image = await _controller!.takePicture();
                                setState(() {
                                  submitting = true;
                                });
                                String result = await widget.onPictureTaken(image.path);
                                if (mounted){
                                  setState(() {
                                    submitting = false;
                                    _resultMessage = result;
                                  });
                                  await Future.delayed(const Duration(seconds: 4));
                                }
                                if (mounted){
                                  setState(() {
                                    _resultMessage = '';
                                  });
                                }
                                                            } catch (e) {
                                print("Erreur lors de la prise de la photo: $e");
                              }
                            },
                            color: CupertinoColors.lightBackgroundGray,
                            padding: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(30.0),
                            child: const Icon(
                              CupertinoIcons.camera, 
                              color: CupertinoColors.darkBackgroundGray,
                              size: 35),
                          ),
                        )
                      )
                    ]
                  )
                ),
              ),
            ]
          );
        } else {
          return _waiting(context);
        }
      },
    );
  }
}