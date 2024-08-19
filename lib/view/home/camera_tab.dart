import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:decodart/widgets/list/list.dart' show ListWidget;
import 'package:decodart/widgets/camera/camera.dart' show CameraWidget;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/view/details/artwork/artwork.dart' show ArtworkDetailsWidget;
import 'package:decodart/api/artwork.dart' show fetchArtworkByImage;

class CameraTabWidget extends StatelessWidget {
  const CameraTabWidget({super.key});

  Future<String> _sendPicture(BuildContext context, String imagePath) async {
    // await Future.delayed(const Duration(seconds: 2));
    var artworks = await fetchArtworkByImage(imagePath);
    
      if (context.mounted && artworks.isNotEmpty) {
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (BuildContext context){
              return ListWidget(
                listName: 'Résultats',
                listContent: artworks,
                onClick: (AbstractListItem item) => ArtworkDetailsWidget(artworkId: item.uid!));
            })
        );
      }
    return 'Artwork not found';
  }

  @override
  Widget build(BuildContext context) {
    return CameraWidget(
      onPictureTaken: (String path) async {
        return _sendPicture(context, path);
      });
  }
}