import 'package:decodart/data/api/artwork.dart' show fetchArtworkById;
import 'package:decodart/data/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/ui/artwork/widgets/artwork.dart' show ArtworkView;
import 'package:decodart/ui/core/util/wait_future.dart' show WaitFutureWidget;
import 'package:flutter/cupertino.dart';

/// A widget that displays an artwork view after fetching the artwork data asynchronously.
/// 
/// The `FutureArtworkView` is a stateless widget that uses a `WaitFutureWidget` to fetch artwork data by its ID.
/// Once the data is fetched, it displays the artwork using the `ArtworkView` widget.
/// 
/// Attributes:
/// 
/// - `artwork` (required): An [ArtworkListItem] that contains the initial artwork data, including the unique identifier (UID) used to fetch the full artwork details.
class FutureArtworkView extends StatelessWidget {
  final ArtworkListItem artwork;
  const FutureArtworkView({
    super.key,
    required this.artwork,
  });
  @override
  Widget build(BuildContext context) {
    return WaitFutureWidget(
      fetch: () => fetchArtworkById(artwork.uid!), builder: (artwork) => ArtworkView(artwork: artwork)
    );
  }
}
