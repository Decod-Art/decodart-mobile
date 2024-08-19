import 'dart:typed_data';
import 'package:flutter/material.dart' show Colors, LayoutBuilder;
import 'package:flutter/cupertino.dart';
import 'package:decodart/model/image.dart' show BoundingBox, AbstractImage;


class ImageGallery extends StatelessWidget {
  final List<AbstractImage> images;
  final bool showBoundingBoxes;
  final void Function(int) onTap;
  final void Function(int) changeImage;
  final void Function(double, double)? onSizeChange;
  final int selected;
  final int selectedImage;
  final bool showArrows;

  const ImageGallery({
    super.key,
    required this.images,
    required this.showBoundingBoxes,
    required this.onTap,
    required this.changeImage,
    this.selected=-1,
    this.selectedImage=0,
    this.onSizeChange,
    this.showArrows=false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageWithBoundingBoxes(
          imagePath: images[selectedImage].path,
          boundingBoxes: images[selectedImage].boundingBoxes??[],
          selected: selected,
          showBoundingBoxes: showBoundingBoxes,
          onTap: onTap,
          onSizeChange: onSizeChange,
        ),
        if (showArrows)
          Positioned(
            left: 5,
            child: CupertinoButton(
              onPressed: () {
                changeImage(selectedImage - 1);
              },
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.back, color: Colors.white),
            ),
          ),
        if (showArrows)
          Positioned(
            right: 5,
            child: CupertinoButton(
              onPressed: () {
                changeImage(selectedImage + 1);
              },
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.forward, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class ImageWithBoundingBoxes extends StatefulWidget {
  final String imagePath;
  final List<BoundingBox> boundingBoxes;
  final bool showBoundingBoxes;
  final void Function(int) onTap;
  final void Function(double, double)? onSizeChange;
  final int selected;


  const ImageWithBoundingBoxes({
    super.key,
    required this.imagePath,
    this.boundingBoxes = const<BoundingBox>[],
    required this.showBoundingBoxes,
    required this.onTap,
    this.selected=-1,
    this.onSizeChange
  });

  @override
  State<ImageWithBoundingBoxes> createState() => _ImageWithBoundingBoxesState();
}

final kTransparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

class _ImageWithBoundingBoxesState extends State<ImageWithBoundingBoxes> {
  double width = 0;
  double height = 0;
  bool shouldRepaint = true;
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //final RenderBox renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox;
    //final size = renderBox.size;
    //print("toto ${size}");
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (shouldRepaint) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              setState(() {
                width = renderBox.size.width;
                height = renderBox.size.height;
                if (widget.onSizeChange != null){
                  widget.onSizeChange!(width, height);
                }
              });
            }
          });
        }
        shouldRepaint = !shouldRepaint;
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              //const CircularProgressIndicator(), // Cet indicateur sera affiché sous l'image
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage, // Vous devez définir kTransparentImage
                image: widget.imagePath,
                key: _imageKey,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 200),
                fadeOutDuration: const Duration(milliseconds: 200),
              ),
              if (widget.showBoundingBoxes)
                ...widget.boundingBoxes.asMap().entries.map((entry) {
                  int index = entry.key;
                  var box = entry.value;
                  return Positioned(
                    left: box.x * width, // Ces valeurs seront mises à jour
                    top: box.y * height, // Ces valeurs seront mises à jour
                    child: GestureDetector(
                      onTap: () {
                        // Sending the bounding box description somewhere...
                        widget.onTap(index);
                      },
                      child: Container(
                        width: box.width * width, // Ces valeurs seront mises à jour
                        height: box.height * height, // Ces valeurs seront mises à jour
                        decoration: BoxDecoration(
                          border: Border.all(color: widget.selected!=index?Colors.red:Colors.green, width: 2),
                        ),
                        child: Text(
                          box.label, // Afficher l'index avec le label
                          style: TextStyle(
                            backgroundColor: widget.selected!=index?Colors.red:Colors.green,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
          )
        );
      }
      );
  }
}

