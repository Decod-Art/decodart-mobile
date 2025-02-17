import 'package:decodart/data/model/artwork.dart' show Artwork;
import 'package:decodart/ui/core/miscellaneous/button/button_list.dart' show ButtonListWidget;
import 'package:decodart/ui/core/miscellaneous/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/ui/core/miscellaneous/formatted_content/content.dart' show ContentWidget;
import 'package:decodart/ui/core/navigation/modal.dart' show showWidgetInModal;
import 'package:decodart/ui/core/navigation/navigate_to_items.dart';
import 'package:flutter/cupertino.dart';

class ArtworkTags extends StatefulWidget {
  final Artwork artwork;
  const ArtworkTags({super.key, required this.artwork});
  
  @override
  State<ArtworkTags> createState() => _ArtworkTagsState();
  
}

class _ArtworkTagsState extends State<ArtworkTags> with SingleTickerProviderStateMixin {
  bool _isButtonListVisible = false;
  bool _isAnimationCompleted = false;
  Artwork get artwork => widget.artwork;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimationCompleted = true;
          });
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            _isAnimationCompleted = false;
          });
        }
      });
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleButtonListVisibility() {
    setState(() {
      if (_isButtonListVisible) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      _isButtonListVisible = !_isButtonListVisible;
    });
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        ChevronButtonWidget(
          text: "Voir les étiquettes",
          icon: const Icon(
            CupertinoIcons.tag,
            color: CupertinoColors.activeBlue,
          ),
          onPressed: _toggleButtonListVisibility,
          chevronDown: _isButtonListVisible,
        ),
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1.0,
          child: Visibility(
            visible: _isButtonListVisible || _isAnimationCompleted,
            child: ButtonListWidget(
              buttons: [
                if (artwork.artist.hasBiography)
                  ChevronButtonWidget(
                    text: "À propos de l'artiste",
                    icon: const Icon(
                      CupertinoIcons.person_circle,
                      color: CupertinoColors.activeBlue,
                    ),
                    onPressed: (){
                      showWidgetInModal(
                        context,
                        (context) => ContentWidget(
                          items: artwork.artist.biography,
                          edges: const EdgeInsets.all(15)
                        )
                      );
                    },
                    leadingSpace: true,
                  ),
                if (artwork.hasMuseum)
                  ChevronButtonWidget(
                    text: artwork.museum.name,
                    icon: Image.asset(
                      'images/icons/museum.png',
                      width: 24,
                      height: 24,
                      color: CupertinoColors.activeBlue,
                    ),
                    onPressed: (){
                      navigateToMuseum(artwork.museum, context, modal: true);
                    },
                    leadingSpace: true,
                  ),
                for(final tag in artwork.sortedTags) ... [
                  ChevronButtonWidget(
                    text: tag.name,
                    icon: Image.asset(
                      _tagIconPath(tag.category.name),
                      width: 24,
                      height: 24,
                      color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
                    ),
                    onPressed: (){
                      showWidgetInModal(
                        context,
                        (context) => ContentWidget(
                          items: tag.description,
                          edges: const EdgeInsets.all(15)
                        )
                      );
                    },
                    leadingSpace: true,
                  )
                ]
              ],
            )
          )
        )
      ]
    );
  }
}

String _tagIconPath(String name){
  switch (name) {
    case "Technique artistique":
      return "images/icons/paintbrush_pointed.png";
    case "Sujet":
      return "images/icons/photo_artframe.png";
    case "Mouvement artistique":
      return "person_crop_square";
    default:
      return "images/icons/text_book_closed.png";
  }
}