import 'package:decodart/view/details/artwork/artwork.dart' show ArtworkDetailsWidget;
import 'package:decodart/widgets/buttons.dart' show ArtworkButton;
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'content.dart';

class ContentWidget extends StatelessWidget {
  final String items;
  final WrapAlignment alignment;
  final EdgeInsets edges;

  const ContentWidget({
    super.key,
    required this.items,
    this.alignment=WrapAlignment.start,
    this.edges=const EdgeInsets.only(bottom: 15, top: 15, right: 15, left: 15)});
  
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
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height, // Couvre toute la hauteur de l'écran
                      color: CupertinoColors.black,
                      child: ArtworkDetailsWidget(artworkId: button.uid),
                    );
                  },
                );
              }));
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