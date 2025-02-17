import 'package:decodart/data/model/abstract_item.dart';
import 'package:decodart/data/model/artwork.dart';
import 'package:decodart/ui/core/miscellaneous/button/artwork_button/button.dart' show ArtworkButton;
import 'package:decodart/ui/core/miscellaneous/image/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '_util.dart';

class ContentWidget extends StatelessWidget {
  final String items;
  final WrapAlignment alignment;
  final EdgeInsets edges;
  final void Function(AbstractListItem) onButtonPressed;

  const ContentWidget({
    super.key,
    required this.items,
    this.alignment=WrapAlignment.start,
    this.edges=const EdgeInsets.only(bottom: 0, top: 0, right: 0, left: 0),
    this.onButtonPressed=_defaultOnButtonPressed});
  
  static void _defaultOnButtonPressed(AbstractListItem item) {
  }

  List<Widget> buildContentWidgets(BuildContext context) {
    List<Widget> contentWidgets = [];
    for (var item in parseString(items)) {
      // Supposons que ImagePath est une chaîne contenant le chemin de l'image.
      // Cette vérification dépend de la structure de vos données.
      switch (item) {
        case ImageContent img:
          contentWidgets.add(DecodImage(img.toOnline()));
          break;
        case TextContent text:
          contentWidgets.add(MarkdownBody(data: text.text, styleSheet: getStyleSheet(context, alignment),));
          break;
        case ArtworkButtonContent button:
          contentWidgets.add(
            ArtworkButton(
              content: button,
              onTap: () => onButtonPressed(ArtworkListItem.fromButton(button))));// Button are restricted to artworks for now
        case _:break;
      }
    }
    return contentWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edges,
      child: Column(
        children: buildContentWidgets(context)
      )
    );
  }
}