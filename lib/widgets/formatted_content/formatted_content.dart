import 'package:decodart/view/details/artwork/artwork.dart' show ArtworkDetailsWidget;
import 'package:decodart/widgets/buttons.dart' show ArtworkButton;
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'content.dart';

class ContentWidget extends StatelessWidget {
  final String items;
  final WrapAlignment alignment;
  final EdgeInsets edges;
  final void Function(int) onButtonPressed;

  const ContentWidget({
    super.key,
    required this.items,
    this.alignment=WrapAlignment.start,
    this.edges=const EdgeInsets.only(bottom: 0, top: 0, right: 0, left: 0),
    this.onButtonPressed=_defaultOnButtonPressed});
  
  static void _defaultOnButtonPressed(int uid) {
  }

  List<Widget> buildContentWidgets(BuildContext context) {
    List<Widget> contentWidgets = [];
    for (var item in parseString(items)) {
      // Supposons que ImagePath est une chaîne contenant le chemin de l'image.
      // Cette vérification dépend de la structure de vos données.
      switch (item) {
        case ImageContent img:
          contentWidgets.add(Image.network(img.path));
          break;
        case TextContent text:
          contentWidgets.add(MarkdownBody(data: text.text, styleSheet: getStyleSheet(context, alignment),));
          break;
        case ArtworkButtonContent button:
          contentWidgets.add(
            ArtworkButton(
              imagePath: button.image.path,
              title: button.title,
              subtitle: button.subtitle,
              onTap: ()=>onButtonPressed(button.uid)));
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