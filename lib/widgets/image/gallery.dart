import 'dart:async';
import 'dart:math';

import 'package:decodart/model/image.dart' show AbstractImage;
import 'package:decodart/widgets/image/full_screen_image_gallery.dart' show FullScreenImageGallery;
import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' show SmoothPageIndicator, WormEffect;

class ImageGallery extends StatefulWidget {
  final List<AbstractImage> images;
  const ImageGallery({
    super.key,
    required this.images,
  });
  
  @override
  State<StatefulWidget> createState() => _ImageGalleryState();

}

class _ImageGalleryState extends State<ImageGallery> {
  final PageController _pageController = PageController();


  final List<Size> sizes = [];

  @override
  void initState(){
    super.initState();
    _loadImageSizes();
  }

  Future<Size> _getImageSize(String imageUrl) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.network(imageUrl);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }

  Future<void> _loadImageSizes() async {
    for (var image in widget.images) {
      final size = await _getImageSize(image.path);
      sizes.add(size);
    }
    setState(() {});
  }

  String _multipleImages() {
    return widget.images.length>1?" Déplacez-vous latéralement pour voir les autres images.":"";
  }

  String _areaOfInterest() {
    bool hasAreaOfInterest = false;
    for(int i = 0 ; i < widget.images.length && !hasAreaOfInterest;i++) {
      hasAreaOfInterest |= widget.images[i].boundingBoxes!=null?widget.images[i].boundingBoxes!.isNotEmpty:false;
    }
    return hasAreaOfInterest?" Touchez sur les zones d'intérêts pour voir leur description. Tapez une fois sur l'image pour masquer les zones d'intérêts":"";
  }

  double _maxImageHeight(){
    if (widget.images.length != sizes.length){
      return double.infinity;
    } else {
      double max = 0;
      final screenWidth = MediaQuery.of(context).size.width;
      for (final size in sizes){
        if (size.height *  screenWidth / size.width > max) {
          max = size.height *  screenWidth / size.width;
        }
      }
      return max;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: min(MediaQuery.of(context).size.height * 0.7, _maxImageHeight()),
            ),
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FullScreenImageGallery(
                            images: widget.images,
                            initialIndex: index,
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                          widget.images[index].path,
                          fit: BoxFit.contain
                        )
                      )
                  )
                );
              }
            ),
          )
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.images.length,
              effect: const WormEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                activeDotColor: CupertinoColors.systemBlue,
                dotColor: CupertinoColors.systemGrey4,
              ),
            ),
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
              const Expanded(
                child: Text(
                  'Touchez l\'image pour l\'ouvrir et obtenir les détails.',
                  style: TextStyle(color: CupertinoColors.systemGrey4, fontSize: 15),)
              )
            ]
          ),
        )
      ]
    );
  }
}