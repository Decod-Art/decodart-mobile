import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'dart:async';

class DownloadButton extends StatefulWidget {
  final VoidCallback startDownload;
  final bool Function() isAvailableOffline;
  final bool Function() isDownloading;
  final double Function() percentOfLoading;
  const DownloadButton({
    super.key,
    required this.startDownload,
    required this.isAvailableOffline,
    required this.isDownloading,
    required this.percentOfLoading
  });

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  Timer? _timer;
  bool _isLoading = false;
  double _percent = 0.0;
  bool _isAvailableOffLine = false;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isDownloading();
    _isAvailableOffLine = widget.isAvailableOffline();
    if (_isLoading) _percent = widget.percentOfLoading();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startDownloading() {
    setState((){
      _isLoading=true;
      widget.startDownload();
    });
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _isLoading = widget.isDownloading();
      if (_isLoading) {
        _percent = widget.percentOfLoading();
      } else {
        _percent = 0.0;
        _isAvailableOffLine = widget.isAvailableOffline();
      }
      setState(() {});

    });
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: _isLoading
        ? LinearProgressIndicator(value: _percent)
        : CupertinoButton(
            onPressed: _isAvailableOffLine ? null : startDownloading,
            child: Text(_isAvailableOffLine ? 'Disponible hors ligne' : 'Rendre disponible hors ligne'),
          )
    );
  }
}