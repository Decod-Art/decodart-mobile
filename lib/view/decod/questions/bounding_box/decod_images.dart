import 'dart:typed_data';
import 'package:decodart/model/image.dart';
import 'package:flutter/material.dart' show Colors, LayoutBuilder;
import 'package:flutter/cupertino.dart';

class ToFindBoundingBox extends BoundingBox {
  bool found;
  ToFindBoundingBox({
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    this.found=false});

  factory ToFindBoundingBox.fromBoundingBox(BoundingBox b) {
    return ToFindBoundingBox(
      x: b.x,
      y: b.y,
      width: b.width, 
      height: b.height);
  }
}

class FindInImageWidget extends StatefulWidget {
  final AbstractImage image;
  final bool showBoundingBoxes=true;
  final void Function(int) foundCorrect;
  final void Function() foundIncorrect;
  final bool isOver;
  final bool isCorrect;


  const FindInImageWidget({
    super.key,
    required this.image,
    required this.foundCorrect,
    required this.foundIncorrect,
    required this.isOver,
    required this.isCorrect
  });

  @override
  State<FindInImageWidget> createState() => _FindInImageWidgetState();
}

final kTransparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

class _FindInImageWidgetState extends State<FindInImageWidget> {
  double width = 0;
  double height = 0;
  bool shouldRepaint = true;
  final GlobalKey _imageKey = GlobalKey();
  late List<ToFindBoundingBox> boundingBoxes = [];

  @override
  void initState() {
    super.initState();
    boundingBoxes = widget.image.boundingBoxes!.map((item)=> ToFindBoundingBox.fromBoundingBox(item)).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      setState(() {});
    });
  }

  @override
void didUpdateWidget(covariant FindInImageWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.image != widget.image) {
    boundingBoxes = widget.image.boundingBoxes!.map((item) => ToFindBoundingBox.fromBoundingBox(item)).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (shouldRepaint) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              setState(() {
                width = renderBox.size.width;
                height = renderBox.size.height;
              });
            }
          });
        }

        shouldRepaint = !shouldRepaint;
        return Center(
          child: GestureDetector(
            onTap: () {
              // if(!widget.isOver){widget.foundIncorrect();}
              },
            child: Stack(
              alignment: Alignment.center,
              children: [
                //const CircularProgressIndicator(), // Cet indicateur sera affiché sous l'image
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      widget.image.path,
                      key: _imageKey),
                    Positioned.fill(
                      child: Container(
                        color: widget.isOver
                          ?widget.isCorrect
                            ?Colors.green.withOpacity(0.5)
                            :Colors.red.withOpacity(0.5)
                          :Colors.transparent
                      ),
                    ),
                  ]
                ),
                ...boundingBoxes.asMap().entries.map((entry) {
                  var box = entry.value;
                  var index = entry.key;
                  return Positioned(
                    left: box.x * width, // Ces valeurs seront mises à jour
                    top: box.y * height, // Ces valeurs seront mises à jour
                    child: GestureDetector(
                      onTap: () {
                        // if (!widget.isOver) {
                        //   box.found = true;
                        //   widget.foundCorrect(index);
                        // }
                      },
                      child: Container(
                        width: box.width * width, // Ces valeurs seront mises à jour
                        height: box.height * height, // Ces valeurs seront mises à jour
                        decoration: BoxDecoration(
                          border: Border.all(color: box.found&&!widget.isOver?Colors.green:Colors.transparent, width: 2),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            )
          )
        );
      }
      );
  }
}

