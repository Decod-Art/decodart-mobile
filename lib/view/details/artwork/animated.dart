import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import "package:decodart/widgets/images.dart" show ImageGallery;
import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/view/decod/manager.dart' show DecodManagerWidget;
import 'package:decodart/widgets/formatted_content/formatted_content_scrolling.dart' show ContentScrolling;


enum PanelPosition {
  top,
  bottom,
  left,
  right,
  center
}

enum AnimationAxis {
  horizontal,
  vertical
}

class AnimatedArtworkView extends StatefulWidget {
  final Artwork artwork;

  const AnimatedArtworkView({super.key, required this.artwork});

  @override
  State<AnimatedArtworkView> createState() => _AnimatedArtworkViewState();
}

class _AnimatedArtworkViewState extends State<AnimatedArtworkView> {
  // Action
  double totalDx = 0;
  double totalDy = 0;
  PanelPosition position = PanelPosition.center;
  AnimationAxis axis = AnimationAxis.horizontal;
  bool swiping = false; // true if user currently swiping.
  
  // current position
  double left = 0;
  double mainRatioLeft = 0; // The main panel might have a shifted position
  double top = 0;
  double mainRatioTop = 0;

  bool showBoundingBox = false;
  int selected = -1;
  int selectedImage = 0;
  String drawerText = '';
  bool showTextDrawer = false;
  bool showArrows = false;

  final double closeButtonHeight = 30;

  final double overlapPercentage = 0.1;
  final double actionPercentage = 0.2;

  double? imgWidth;
  double? imgHeight;

  double _screenWidth() {
    return MediaQuery.of(context).size.width - MediaQuery.of(context).padding.left - MediaQuery.of(context).padding.right;
  }

  double _screenHeight() {
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top-closeButtonHeight;
  }

  void _onSwipe(DragUpdateDetails updateDetails) {
    setState(() {
      swiping = true;
      // The first test means that the animation just began
      if (totalDx == 0 && totalDy == 0) {
        if (updateDetails.delta.dx.abs() > updateDetails.delta.dy.abs()) {
          axis = AnimationAxis.horizontal;
        } else {
          axis = AnimationAxis.vertical;
        }
      }
      totalDx += updateDetails.delta.dx;
      totalDy += updateDetails.delta.dy;
      var coordinates = _position();
      switch (axis) {
        case AnimationAxis.vertical:
          switch (position){
            case PanelPosition.center || PanelPosition.top || PanelPosition.bottom:
              top = coordinates.top + totalDy;
              break;
            case _:
              break;
          }
          break;
        case AnimationAxis.horizontal:
          switch(position){
            case PanelPosition.center || PanelPosition.left || PanelPosition.right:
              left = coordinates.left + totalDx;
              break;
            case _:
              break;

          }
          break;
      }
    });
  }

  void _onSwipeEnd(DragEndDetails updateDetails) {
    // Speed could be based on velocity
    setState(() {
      swiping = false;
      switch(axis){
        case AnimationAxis.horizontal:
          switch(position){
            case PanelPosition.left || PanelPosition.right:
              if (totalDx.abs() > actionPercentage * _screenWidth()) {
                position = PanelPosition.center;
              }
              break;
            case PanelPosition.center:
              if (-totalDx > actionPercentage * _screenWidth()) {
                position = PanelPosition.left;
              } else if (totalDx > actionPercentage * _screenWidth()) {
                position = PanelPosition.right;
              }
              break;
            case _: break; // animation horizontal only works for horizontal current position
          }
          break;
        case AnimationAxis.vertical:
          switch(position){
            case PanelPosition.top || PanelPosition.bottom:
              if (totalDy.abs() > actionPercentage * _screenHeight()) {
                position = PanelPosition.center;
              }
              break;
            case PanelPosition.center:
              if (-totalDy > actionPercentage * _screenHeight()) {
                position = PanelPosition.top;
              } else if (totalDy > actionPercentage * _screenHeight()) {
                position = PanelPosition.bottom;
              }
              break;
            case _: break; // animation horizontal only works for horizontal current position
          }
          break;
      }
    });
    if (position == PanelPosition.top) {
      // If the position is top, then we get inside the decoder screen
      position = PanelPosition.center;
      if (widget.artwork.hasDecodQuestion) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => DecodManagerWidget(artworkId: widget.artwork.uid!),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      }
    }
  }

  ({double left, double top}) _position() {
    switch(position){
      case PanelPosition.center:
        return (left: 0, top : 0);
      case PanelPosition.top:
        return (left: 0,  top: - (1-overlapPercentage) * _screenHeight());
      case PanelPosition.bottom:
        return (left: 0, top: (1-overlapPercentage) * _screenHeight());
      case PanelPosition.left:
        return (left: - (1-overlapPercentage) * _screenWidth(), top: 0);
      case PanelPosition.right:
        return (left: (1-overlapPercentage) * _screenWidth(), top: 0);
    }
  }

  void _setupPosition() {
    var coordinates = _position();
    left = coordinates.left;
    top = coordinates.top;
  }

  void mainImageSize(double width, double height){
      imgWidth = width;
      imgHeight = height;
      mainRatioLeft = ((_screenWidth()-imgWidth!)/2+imgWidth!-overlapPercentage*_screenWidth())/((1-overlapPercentage)*_screenWidth());
      mainRatioTop = ((_screenHeight()-imgHeight!)/2+imgHeight!-overlapPercentage*_screenHeight())/((1-overlapPercentage)*_screenHeight());
      setState(() {});
  }

  void _selectBoundingBox(int idx){
    setState(() {
      selected = idx;
      showTextDrawer = true;
      drawerText = widget.artwork.images[selectedImage].boundingBoxes![selected].description;
    });
  }

  Widget mainScreen() {
    return AnimatedPositioned(
      duration: swiping?Duration.zero:const Duration(milliseconds: 100),
      left: mainRatioLeft * left,
      top: mainRatioTop * top,
      child: SizedBox(
        width: _screenWidth(),
        height: _screenHeight(),
        child: GestureDetector( // to capture on tap to show the bounding boxes
          child: Stack(
            children: [
              ImageGallery(
                images: widget.artwork.images,
                showBoundingBoxes: showBoundingBox,
                onTap: _selectBoundingBox,
                selected: selected,
                selectedImage: selectedImage,
                onSizeChange: mainImageSize,
                changeImage: (int a) {
                  setState(() {
                    selectedImage = a % widget.artwork.images.length;
                    showBoundingBox = false;
                    showTextDrawer = false;
                  });},
                showArrows: showArrows && position == PanelPosition.center && !swiping,
              ),
              if (showTextDrawer)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: _screenWidth(),
                    color: Colors.black.withOpacity(0.5), // Noir avec 50% d'opacité
                    padding: const EdgeInsets.all(10), // Ajustez le padding selon vos besoins
                    child: Text(
                      drawerText,
                      style: const TextStyle(color: Colors.white, fontSize: 16), // Ajustez le style de texte selon vos besoins
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ]
          ),
          onTap: () {
            setState(() {
              showBoundingBox= !showBoundingBox;
              selected = -1;
              showTextDrawer = false;
            }); 
          }
        )
      )
    );
  }

  Widget artworkScreen() {
    return AnimatedPositioned(
      duration: swiping?Duration.zero:const Duration(milliseconds: 100),
      left: left,
      top: top-_screenHeight()* (1-overlapPercentage),
      child: SizedBox( // Assurez-vous que le conteneur a une couleur
        width: _screenWidth(),
        height: _screenHeight() * (1-overlapPercentage),
        child: ContentScrolling(
          text: widget.artwork.description,
        )
      )
    );
  }
  
  Widget authorScreen() {
    return AnimatedPositioned(
      duration: swiping?Duration.zero:const Duration(milliseconds: 100),
      left: left+_screenWidth(),
      top: top,
      child: SizedBox( // Assurez-vous que le conteneur a une couleur
        width: _screenWidth() * (1-overlapPercentage),
        height: _screenHeight(),
        child: ContentScrolling(
          text: widget.artwork.artist.biography,
          alignment: WrapAlignment.start,
        )
      )
    );
  }

  Widget contextScreen() {
    return AnimatedPositioned(
      duration: swiping?Duration.zero:const Duration(milliseconds: 100),
      left: left-_screenWidth() * (1-overlapPercentage),
      top: top,
      child: SizedBox( // Assurez-vous que le conteneur a une couleur
        width: _screenWidth() * (1-overlapPercentage),
        height: _screenHeight(),
        child: ContentScrolling(
          text: widget.artwork.context.description,
        )
      )
    );
  }

  Widget _widget(BuildContext context) {
    if(!swiping)_setupPosition();
    showArrows = widget.artwork.images.length > 1;
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: CupertinoColors.black,
            child: Center(
              child: SizedBox(
                width: 100,
                height: closeButtonHeight,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
                    color: const Color.fromARGB(255, 68, 68, 68),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Retour',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14),
                    ),
                  ),
                )
              )
            ),
          ),
          
          GestureDetector(
            onPanStart: (details) {
              // Réinitialiser les déplacements accumulés au début du geste
              totalDx = 0;
              totalDy = 0;
              showTextDrawer = false;
              selected = -1;
            },
            onPanUpdate: (details) {
              _onSwipe(details);
            },
            onPanEnd: (details) {
              _onSwipeEnd(details);
            },
            onLongPress: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.black,
              width: _screenWidth(),
              height: _screenHeight(),
              child: Stack(
                children: [
                  mainScreen(),
                  artworkScreen(),
                  authorScreen(),
                  contextScreen(),
                ],
              ),
            )
          )
        ],
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    // Show a loading screen
    return Center(
      // Utilisez les données de l'artwork pour construire votre widget
      child: _widget(context), // Exemple, remplacez par votre UI
    );
  }
}
