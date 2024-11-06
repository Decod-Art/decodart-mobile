import 'package:decodart/model/image.dart' show AbstractImage;
import 'package:decodart/widgets/component/image/with_area_of_interest/image.dart' show ImageWithAreaOfInterest;
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageGallery extends StatefulWidget {
  final List<AbstractImage> images;
  final int initialIndex;

  const FullScreenImageGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageGallery> createState() => _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<FullScreenImageGallery> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions.customChild(
                disableGestures: true,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: CupertinoColors.black,
                  child: SafeArea(
                    child: ClipRect(
                      child: ImageWithAreaOfInterest(
                        image: widget.images[index]
                      )
                    )
                  )
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.images[index]),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: CupertinoColors.black,
            ),
          ),
          Positioned(
            top: 40.0,
            left: 20.0,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(CupertinoIcons.clear, color: CupertinoColors.white),
            ),
          ),
        ],
      ),
    );
  }
}