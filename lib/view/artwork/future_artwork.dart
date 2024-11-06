import 'package:decodart/api/artwork.dart' show fetchArtworkById;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/view/artwork/artwork.dart' show ArtworkView;
import 'package:decodart/widgets/util/wait_future.dart' show WaitFutureWidget;
import 'package:flutter/cupertino.dart';

class FutureArtworkView extends StatelessWidget {
  final ArtworkListItem artwork;
  const FutureArtworkView({
    super.key,
    required this.artwork,
  });
  @override
  Widget build(BuildContext context) {
    return WaitFutureWidget(
      fetch: () => fetchArtworkById(artwork.uid!),
      builder: (artwork) => ArtworkView(artwork: artwork)
    );
  }
}
