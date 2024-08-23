import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/view/artwork/future_artwork.dart';
import 'package:decodart/widgets/new_decod_bar.dart';
import 'package:flutter/cupertino.dart';

class FullScreenFutureArtworkView extends StatelessWidget {
  final Future<Artwork> artwork;
  const FullScreenFutureArtworkView({
    super.key,
    required this.artwork
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
          child: FutureArtworkView(artwork: artwork)
        )
      )
    );
  }
}