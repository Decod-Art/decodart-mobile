import 'dart:typed_data' show Uint8List;

import 'package:decodart/data/model/artwork.dart' show Artwork;
import 'package:decodart/data/model/decod.dart' show DecodQuestion;
import 'package:decodart/data/model/image.dart' show ImageOnline;
import 'package:decodart/data/model/museum.dart' show Museum;
import 'package:decodart/data/model/tour.dart' show Tour;

/// Mixin to handle the offline loading of images.
mixin ImageOffline {
  /// Loads images associated with artworks.
  ///
  /// This method iterates through the artworks and downloads each image associated
  /// with the artwork, its description, and the artist's biography.
  ///
  /// [artworks] A map where the keys are artwork IDs and the values are [Artwork] objects.
  /// [images] A map to store the downloaded images, where the keys are image URLs and the values are [Uint8List] of image data.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  Future<void> loadImageFromArtworks(Map<int, Artwork> artworks, Map<String, Uint8List> images, {int pause = 25}) async {
    for (final entry in artworks.entries) {
      final artwork = entry.value;
      for (final image in artwork.images) {
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));
      }
      // The description is parsed to retrieved image that might have been referred
      for (final image in extractImages(artwork.description)) {
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));
      }
      // The biography is parsed to retrieved image that might have been referred
      for (final image in extractImages(artwork.artist.biography)) {
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));
      }
    }
  }

  /// Loads images associated with questions.
  ///
  /// This method iterates through the questions and downloads each image associated
  /// with the question and its answers.
  ///
  /// [questions] A map where the keys are the artwork IDs the q is associated to and the values
  ///  are lists of [DecodQuestion] objects.
  /// [images] A map to store the downloaded images, where the keys are image URLs and the values are [Uint8List] of image data.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  Future<void> loadImageFromQuestions(Map<int, List<DecodQuestion>> questions, Map<String, Uint8List> images, {int pause=25}) async {
    for(final entry in questions.entries){
      final questions = entry.value;
      for (final q in questions) {
        // Direct images
        final image = q.image;
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));

        for(final a in q.answers) {
          final image = a.image;
          if (image != null) {
            await downloadImage(image, images);
            await Future.delayed(Duration(milliseconds: pause));
          }
        }
        // Images through text
        for(final image in extractImages(q.question)) {
          await downloadImage(image, images);
          await Future.delayed(Duration(milliseconds: pause));
        }
        for(final a in q.answers) {
          final text = a.text;
          if (text != null) {
            for(final image in extractImages(text)) {
              await downloadImage(image, images);
              await Future.delayed(Duration(milliseconds: pause));
            }
          }
        }
      }
    }
  }
  
  /// Loads images associated with Tours and Exhibitions.
  ///
  /// This method iterates through the tours and exhibitions and downloads 
  /// each image associated with the tours' description and the associated artworks.
  ///
  /// [tours] A map where the keys are tours IDs and the values are lists of [Tour] objects.
  /// [images] A map to store the downloaded images, where the keys are image URLs and the values are [Uint8List] of image data.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  Future<void> loadImageFromTours(Map<int, Tour> tours, Map<String, Uint8List> images, {int pause=25}) async {
    for(final entry in tours.entries){
      final tour = entry.value;
      final image = tour.image;
      await downloadImage(image, images);
      await Future.delayed(Duration(milliseconds: pause));
      for (final artwork in tour.artworks) {
        final image = artwork.image;
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));
      }
      for(final image in extractImages(tour.description)) {
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));
      }
    }
  }

  /// Loads images associated with a museum
  ///
  /// This method download the image of a museum and images that might have been referred from
  /// the description of the museum
  ///
  /// [museum] The museum the image will be taken from.
  /// [images] A map to store the downloaded images, where the keys are image URLs and the values are [Uint8List] of image data.
  /// [pause] The duration of the pause between requests in milliseconds (default is 25 ms).
  Future<void> loadImageFromMuseum(Museum museum, Map<String, Uint8List> images, {int pause=25}) async {
    final image = museum.image;
    await downloadImage(image, images);
    await Future.delayed(Duration(milliseconds: pause));
    for(final image in extractImages(museum.description)) {
      await downloadImage(image, images);
      await Future.delayed(Duration(milliseconds: pause));
    }
  }

  /// Downloads an image and stores it in the provided map.
  ///
  /// [image] The [ImageOnline] object representing the image to be downloaded.
  /// [images] A map to store the downloaded image, where the key is the image URL and the value is the [Uint8List] of image data.
  Future<void> downloadImage(ImageOnline image, Map<String, Uint8List> images) async {
    final imagePath = image.path;
    if (!images.containsKey(imagePath)) {
      final data = await image.downloadImageData(keep: false);
      images[imagePath] = data;
    }
  }

  /// Extracts image URLs from a given text.
  ///
  /// This method parses the provided text and extracts any image URLs found within it.
  ///
  /// [text] The text from which to extract image URLs.
  ///
  /// Returns a list of [ImageOnline] objects representing the extracted images.
  List<ImageOnline> extractImages(String description) {
    final RegExp regex = RegExp(r'!\[.*?\]\((.*?)\)');
    final matches = regex.allMatches(description);
    return matches.map((match) => ImageOnline(match.group(1)!)).toList();
  }
}