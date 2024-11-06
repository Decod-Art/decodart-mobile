import 'package:decodart/widgets/component/formatted_content/_util.dart' show ArtworkButtonContent;
import 'package:decodart/widgets/component/button/artwork_button/util/info.dart' show InfoLogo;
import 'package:decodart/widgets/component/button/artwork_button/util/title.dart' show TitleAndSubtitle;
import 'package:flutter/cupertino.dart';

class ArtworkButton extends StatelessWidget {
  final ArtworkButtonContent content;
  final VoidCallback onTap;

  const ArtworkButton({
    super.key,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(content.image.path),
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Stack(
                  children: [
                    TitleAndSubtitle(
                      title: content.title,
                      subtitle: content.subtitle
                    ),
                    const InfoLogo()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}