import 'package:decodart/data/model/pdf.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:decodart/util/logger.dart' show logger;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DecodPDF extends StatefulWidget {
  final PDFOnline pdf;
  final VoidCallback? onLoading;
  final VoidCallback? onError;
  const DecodPDF(
    this.pdf, 
    {
      super.key,
      this.onLoading,
      this.onError
    }
  );
  
  @override
  State<DecodPDF> createState() => _DecodPDFState();

}

class _DecodPDFState extends State<DecodPDF> {
  bool _isLoading = true;
  bool _hasFailed = false;
  late Uint8List data;

  @override
  void initState() {
    super.initState();
    downloadContent();

  }

  @override
  void didUpdateWidget(covariant DecodPDF oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pdf != oldWidget.pdf) {
      downloadContent();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> downloadContent() async {
    setState(() {_isLoading = true;});
    try {
      final results = await Future.wait([widget.pdf.downloadData(), Future.delayed(Duration(milliseconds: 400))]);
      data = results[0] as Uint8List;
    } catch(e) {
      _hasFailed = true;
      logger.e(e);
    }
    if(context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {_isLoading = false;});
        if (_hasFailed) widget.onError?.call();
      });
    }
  }

  PDFOnline get pdf => widget.pdf;

  @override
  Widget build(BuildContext context) {
    return _isLoading
      ? Center(
          child: CircularProgressIndicator(),
        )
    : _hasFailed
        ? Image.asset('images/img_404.jpeg', fit: BoxFit.cover, width: double.infinity, height: double.infinity)
        : SfPdfViewer.memory(data);
  } 
}
