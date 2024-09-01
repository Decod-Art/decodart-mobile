import 'package:decodart/api/artwork.dart' show fetchArtworkById;
import 'package:decodart/model/artwork.dart' show Artwork;
import 'package:decodart/view/artwork/artwork.dart' show ArtworkView;
import 'package:decodart/widgets/new_decod_bar.dart';
import 'package:flutter/cupertino.dart';

class FutureArtworkView extends StatefulWidget {
  final int artworkId;
  final bool fullScreen;
  const FutureArtworkView({
    super.key,
    required this.artworkId,
    this.fullScreen=false
  });
  
  @override
  State<FutureArtworkView> createState() => _FutureArtworkViewState();
}

class _FutureArtworkViewState extends State<FutureArtworkView> {

  late Future<Artwork> artwork;
  
  @override
  void initState(){
    super.initState();
    artwork = fetchArtworkById(widget.artworkId);
  }

  Widget _pageView(BuildContext context, FutureBuilder builder) {
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
        child: builder
      )
    );
  }

  FutureBuilder _builder(BuildContext context) {
    return FutureBuilder<Artwork>(
      future: artwork,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          final screenSize = MediaQuery.of(context).size;
          return Center(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              color: CupertinoColors.white, // Fond blanc
              child: const CupertinoActivityIndicator(),
              ),
            );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erreur : ${snapshot.error}',
              style: const TextStyle(color: CupertinoColors.systemRed),
            ),
          );
        } else if (snapshot.hasData) {
          final artwork = snapshot.data!;
          return widget.fullScreen
            ?  SingleChildScrollView(child: ArtworkView(artwork: artwork))
            : ArtworkView(artwork: artwork);
        } else {
          return const Center(
            child: Text('Aucune donnée disponible'),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fullScreen) {
      return _pageView(context, _builder(context));
    }
    return _builder(context);
  }
}