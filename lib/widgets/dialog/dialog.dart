import 'package:flutter/cupertino.dart';

Future<T?> showDialog<T>(
  BuildContext context,
  {
    required Widget content,
    required VoidCallback onPressedOk,
    String title='Confirmation',
    String ok='Ok'
  }){
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: content,
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('Annuler', style: TextStyle(color: CupertinoColors.systemRed),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            onPressed: onPressedOk,
            child: Text(ok),
          ),
        ],
      );
    },
  );
}