import 'package:flutter/cupertino.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onPress;
  const ErrorView({super.key, required this.onPress});
  @override
  Widget build(BuildContext context){
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final safeAreaHeight = screenSize.height - padding.top - padding.bottom;
    return Container(
      width: screenSize.width,
      height: safeAreaHeight-300,
      color: CupertinoColors.white, // Fond blanc
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Une erreur s\'est produite...'),
          CupertinoButton(
            onPressed: onPress, // Assurez-vous d'avoir une méthode _refresh définie
            child: Text('Rafraîchir'),
          ),
        ],
      ),
    );
  }
}