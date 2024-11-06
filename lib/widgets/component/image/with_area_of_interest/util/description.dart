import 'package:decodart/model/image.dart' show BoundingBox;
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/cupertino.dart';

class Description extends StatelessWidget {
  final BoundingBox? selectedBox;
  final VoidCallback onReturnPressed;
  const Description({super.key, required this.selectedBox, required this.onReturnPressed});

  @override
  Widget build(BuildContext context){
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      bottom: selectedBox!=null ? 0 : -200, // Adjust the height as needed
      left: 0,
      right: 0,
      child: Container(
        height: 200, // Adjust the height as needed
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Ajustez les marges internes si nécessaire
                onPressed: onReturnPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // Fond noir transparent
                    borderRadius: BorderRadius.circular(30), // Extrémités arrondies
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 15, top: 5, bottom: 5), // Ajustez les marges internes si nécessaire
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.arrow_left, color: Colors.white, size: 16,),
                      SizedBox(width: 10,),
                      Text("Retour", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                selectedBox?.description??"",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}