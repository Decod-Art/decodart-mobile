import 'dart:async';
import 'package:decodart/model/image.dart' show AbstractImage;
import 'package:decodart/widgets/image/image_with_area_of_interest.dart' show ImageWithAreaOfInterest;
import 'package:flutter/cupertino.dart';

class ImageGallery extends StatelessWidget {
  final List<AbstractImage> images;
  const ImageGallery({
    super.key,
    required this.images,
  });

  Future<List<Size>> _getAllImageSizes() async {
    List<Future<Size>> futures = images.map((image) => _getImageSize(image.path)).toList();
    return await Future.wait(futures);
  }

  Future<Size> _getImageSize(String imageUrl) {
    Completer<Size> completer = Completer();
    Image image = Image.network(imageUrl);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );
    return completer.future;
  }

  String _multipleImages() {
    return images.length>1?" Déplacez-vous latéralement pour voir les autres images.":"";
  }

  String _areaOfInterest() {
    bool hasAreaOfInterest = false;
    for(int i = 0 ; i < images.length && !hasAreaOfInterest;i++) {
      hasAreaOfInterest |= images[i].boundingBoxes!=null?images[i].boundingBoxes!.isNotEmpty:false;
    }
    return hasAreaOfInterest?" Touchez sur les zones d'intérêts pour voir leur description.":"";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Size>>(
          future: _getAllImageSizes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Icon(CupertinoIcons.exclamationmark_circle));
            } else {
              final imageSizes = snapshot.data!;
              var aspectRatio = double.infinity;
              for (var size in imageSizes) {
                if (size.width / size.height < aspectRatio) {
                  aspectRatio = size.width / size.height;
                }
              }
              return Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return ImageWithAreaOfInterest(image: images[index]);
                    }
                  ),
                )
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            children: [
              Image.asset(
                'images/icons/plus_magnifyingglass.png',
                width: 15,
                height: 15,
                color: CupertinoColors.systemGrey4, // Optionnel : pour colorer l'icône
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: Text(
                  'Pincez pour zoomer et voir les détails.${_multipleImages()}${_areaOfInterest()}',
                  style: const TextStyle(color: CupertinoColors.systemGrey4, fontSize: 15),)
              )
            ]
          ),
        )
      ]
    );
  }
}