import 'package:flutter/cupertino.dart';


class CameraButtonWidget extends StatelessWidget {
  final bool canTakePicture;
  final bool isSearching;
  final VoidCallback onPressed;

  const CameraButtonWidget({
    super.key,
    required this.onPressed,
    required this.canTakePicture,
    required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: canTakePicture?onPressed:null,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSearching||!canTakePicture?CupertinoColors.systemGrey3:CupertinoColors.black,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3), // Ajustez cette valeur pour contrôler l'offset de la bordure
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CupertinoColors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isSearching)
            const SizedBox(
              width: 40,
              height: 40,
              child: CupertinoActivityIndicator(),
            ),
        ],
      ),
    );
  }
}