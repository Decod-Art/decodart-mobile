import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' show SfPdfViewer;

class FullScreenPDFViewer extends StatelessWidget {
  final String pdfUrl;

  const FullScreenPDFViewer({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.black, // Fond sombre pour la barre de navigation
        middle: const Text('Plan du musée', style: TextStyle(color: Colors.white)),
        leading: CupertinoNavigationBarBackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: Container(
        color: Colors.black, // Fond sombre
        child: SfPdfViewer.network(
          pdfUrl,
        ),
      ),
    );
  }
}