import 'package:flutter/cupertino.dart';

class Error extends StatelessWidget {
  final VoidCallback onPress;
  const Error({super.key, required this.onPress});
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Text('Une erreur s\'est produite'),
          CupertinoButton(
            onPressed: onPress, // Assurez-vous d'avoir une méthode _refresh définie
            child: Text('Rafraîchir'),
          ),
        ],
      ),
    );
  }
}