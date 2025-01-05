import 'dart:typed_data' show Uint8List;

import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/model/decod.dart';
import 'package:decodart/model/image.dart';
import 'package:decodart/model/museum.dart';
import 'package:decodart/model/tour.dart';

mixin ImageOffline {
  Future<void> loadImageFromArtworks(Map<int, Artwork> artworks, Map<String, Uint8List> images, {int pause = 25}) async {
    for (final entry in artworks.entries) {
      final artwork = entry.value;
      for (final image in artwork.images) {
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));
      }
      for (final image in extractImages(artwork.description)) {
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));
      }
      for (final image in extractImages(artwork.artist.biography)) {
        await downloadImage(image, images);
        await Future.delayed(Duration(milliseconds: pause));
      }
    }
  }
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

  Future<void> loadImageFromMuseum(Museum museum, Map<String, Uint8List> images, {int pause=25}) async {
    final image = museum.image;
    await downloadImage(image, images);
    await Future.delayed(Duration(milliseconds: pause));
    for(final image in extractImages(museum.description)) {
      await downloadImage(image, images);
      await Future.delayed(Duration(milliseconds: pause));
    }
  }

  // From museum

  Future<void> downloadImage(ImageOnline image, Map<String, Uint8List> images) async {
    final imagePath = image.path;
    if (!images.containsKey(imagePath)) {
      final data = await image.downloadImageData(keep: false);
      images[imagePath] = data;
    }
  }

  List<ImageOnline> extractImages(String description) {
    final RegExp regex = RegExp(r'!\[.*?\]\((.*?)\)');
    final matches = regex.allMatches(description);
    return matches.map((match) => ImageOnline(match.group(1)!)).toList();
  }
}