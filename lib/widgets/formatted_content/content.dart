import 'package:decodart/api/util.dart' show checkUrlForCdn;
import 'package:decodart/model/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Theme;
import 'package:flutter_markdown/flutter_markdown.dart';

class AbstractFormattedContent {
  const AbstractFormattedContent();
}

class ImageContent extends AbstractFormattedContent {
  final String imagePath;
  
  const ImageContent(
    this.imagePath,
  );
  String get path {
    return checkUrlForCdn(imagePath)!;
  }

}

class TextContent extends AbstractFormattedContent {
  final String text;
  const TextContent(this.text);
}

class ArtworkButtonContent extends AbstractFormattedContent {
  final String title;
  final String subtitle;
  final AbstractImage image;
  final int uid;
  const ArtworkButtonContent({required this.title, required this.subtitle, required this.image, required this.uid});
}

List<AbstractFormattedContent> parseString(String input) {
  RegExp imageRegExp = RegExp(r'\[.*?\]\((.*?)\)');
  RegExp buttonRegExp = RegExp(r'\[title:(.*?),subtitle:(.*?),uid:(.*?)\]\((.*?)\)');

  // Diviser la chaîne en lignes
  List<String> lines = input.split('\n');

  // Liste pour stocker les sous-chaînes
  List<AbstractFormattedContent> result = [];
  StringBuffer currentChunk = StringBuffer();

  for (String line in lines) {
    if (buttonRegExp.hasMatch(line)){
      if (currentChunk.isNotEmpty) {
        result.add(TextContent(currentChunk.toString().trim()));
        currentChunk.clear();
      }
      Match match = buttonRegExp.firstMatch(line)!;
      String title = match.group(1)!;
      String subtitle = match.group(2)!;
      int uid = int.parse(match.group(3)!);
      String imagePath = match.group(4)!;
      result.add(ArtworkButtonContent(
        title: title,
        subtitle: subtitle,
        image: ImageWithPath(imagePath),
        uid:  uid));
    } else if (imageRegExp.hasMatch(line)) {
      // Ajouter le chunk actuel à la liste s'il n'est pas vide
      if (currentChunk.isNotEmpty) {
        result.add(TextContent(currentChunk.toString().trim()));
        currentChunk.clear();
      }
      // Ajouter la ligne correspondante directement à la liste
      Match match = imageRegExp.firstMatch(line)!;
      String imagePath = match.group(1)!;
      result.add(ImageContent(imagePath));
    } else {
      // Ajouter la ligne au chunk actuel
      if (currentChunk.isNotEmpty) {
        currentChunk.writeln();
      }
      currentChunk.write(line);
    }
  }

  // Ajouter le dernier chunk à la liste s'il n'est pas vide
  if (currentChunk.isNotEmpty) {
    result.add(TextContent(currentChunk.toString().trim()));
  }
  return result;
}

MarkdownStyleSheet getStyleSheet(BuildContext context, WrapAlignment alignment) {
  return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: const TextStyle(fontSize: 14), // Set the text color to white
      h1: const TextStyle(fontSize: 20), // Set the header color to white
      h2: const TextStyle(fontSize: 22),
      h2Padding: const EdgeInsets.only(bottom: 15),
      h3: const TextStyle(),
      h4: const TextStyle(),
      h5: const TextStyle(),
      h6: const TextStyle(),
      listBullet: const TextStyle(),
      textAlign: alignment
    );
}