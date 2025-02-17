import 'package:decodart/data/model/artwork.dart' show Artwork;
import 'package:decodart/ui/artwork/widgets/components/decod_button.dart' show DecodButton;
import 'package:decodart/ui/artwork/widgets/components/tags.dart' show ArtworkTags;
import 'package:decodart/ui/core/miscellaneous/formatted_content/content.dart' show ContentWidget;
import 'package:decodart/ui/core/miscellaneous/gallery/gallery.dart' show ImageGallery;
import 'package:flutter/cupertino.dart';

/// A widget that displays detailed information about an artwork.
/// 
/// The `ArtworkView` is a stateless widget that presents various details about an artwork, including its title, artist, year, tags, and images.
/// It also provides buttons for additional information and interactions.
/// 
/// Attributes:
/// 
/// - `artwork` (required): An [Artwork] object that contains all the details about the artwork, including title, artist, year, tags, images, and descriptions.
class ArtworkView extends StatelessWidget {
  final Artwork artwork;
  const ArtworkView({
    super.key,
    required this.artwork
  });

  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            artwork.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
          child: Text(
            "${artwork.artist.name}, ${artwork.year}",
            style: const TextStyle(fontSize: 20)
          )
        ),
        const SizedBox(height: 20),
        ArtworkTags(artwork: artwork),
        const SizedBox(height: 5),
        if(artwork.hasDecodQuestion)
          DecodButton(artwork: artwork),
        const SizedBox(height: 20),
        ImageGallery(
          images: artwork.images
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: ContentWidget(
              items: artwork.description,
            )
          ),
        const SizedBox(height: 25)
      ],
    );
  }
}