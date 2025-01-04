import 'dart:async';
import 'dart:math';

import 'package:decodart/model/image.dart' show ImageOnline;
import 'package:decodart/widgets/component/gallery/full_screen_gallery.dart' show FullScreenImageGallery;
import 'package:decodart/widgets/component/gallery/util/info_gallery.dart' show InfoGallery;
import 'package:decodart/widgets/component/gallery/util/page_indicator.dart' show PageIndicator;
import 'package:decodart/widgets/component/image/image.dart';
import 'package:flutter/cupertino.dart';

class ImageGallery extends StatefulWidget {
  final List<ImageOnline> images;
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

  Future<void> _loadImageSizes() async {
    for (var image in widget.images) {
      final size = await image.getDimension();
      sizes.add(size);
    }
    setState(() {});
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
              maxHeight: min(MediaQuery.of(context).size.height * 0.75, _maxImageHeight()),
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
                      child: DecodImage(
                          widget.images[index],
                          fit: BoxFit.contain
                        )
                      )
                  )
                );
              }
            ),
          )
        ),
        PageIndicator(
          length: widget.images.length,
          controller: _pageController,
        ),
        const InfoGallery()
      ]
    );
  }
}