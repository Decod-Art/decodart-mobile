import 'package:decodart/widgets/formatted_content/formatted_content.dart' show ContentWidget;
import 'package:flutter/cupertino.dart';

class ContentScrolling extends StatelessWidget {
  final String text;
  final WrapAlignment alignment;
  final EdgeInsets edges;

  const ContentScrolling({
    super.key,
    required this.text,
    this.alignment=WrapAlignment.start,
    this.edges=const EdgeInsets.only(bottom: 0, top: 0, right: 0, left: 0)});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ContentWidget(
        items: text,
        alignment: alignment,
        edges: edges
      )
    );
  }
}
