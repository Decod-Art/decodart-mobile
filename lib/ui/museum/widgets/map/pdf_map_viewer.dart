import 'package:decodart/data/model/pdf.dart' show PDFOnline;
import 'package:decodart/ui/core/miscellaneous/pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class FullScreenPDFViewer extends StatelessWidget {
  final PDFOnline pdf;

  const FullScreenPDFViewer({super.key, required this.pdf});

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
        child: DecodPDF(pdf),
      ),
    );
  }
}