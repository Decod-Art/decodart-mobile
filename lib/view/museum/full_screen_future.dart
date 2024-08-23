import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/view/museum/future_museum.dart' show FutureMuseumView;
import 'package:decodart/widgets/new_decod_bar.dart';
import 'package:flutter/cupertino.dart';

class FullScreenFutureMuseumView extends StatelessWidget {
  final Future<Museum> museum;
  const FullScreenFutureMuseumView({
    super.key,
    required this.museum
    });

  

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: NewDecodNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
              SizedBox(width: 4),
              Text('Retour', style: TextStyle(color: CupertinoColors.activeBlue)),
            ],
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
            child: FutureMuseumView(museum: museum)
        )
      )
    );
  }
}