import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/tour.dart' show fetchAllTours, fetchTourById;
import 'package:decodart/api/util.dart';
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/artwork.dart';
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/model/tour.dart';
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/widgets/list/content_block.dart' show ContentBlock;
import 'package:decodart/view/tour/future_tour.dart' show FutureTourView;
import 'package:decodart/widgets/formatted_content/formatted_content_scrolling.dart' show ContentScrolling;
import 'package:decodart/widgets/modal_or_fullscreen/modal.dart' show ShowModal;
import 'package:decodart/widgets/modal_or_fullscreen/modal_or_fullscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;

class MuseumView extends StatefulWidget {
  final Museum museum;
  final bool useModal;

  const MuseumView({
    super.key,
    required this.museum,
    this.useModal=true
  });

  @override
  State<MuseumView> createState() => _MuseumViewState();
}

class _MuseumViewState extends State<MuseumView>  with ShowModal {
  final ScrollController _scrollController = ScrollController();
  late final SearchableDataFetcher<ArtworkListItem> _fetchCollection;
  late final SearchableDataFetcher<TourListItem> _fetchExhibition;
  late final SearchableDataFetcher<TourListItem> _fetchTour;

  @override
  void initState() {
    super.initState();
    _fetchCollection = ({int limit=10, int offset=0, String? query}) {
      return fetchAllArtworks(limit: limit, offset: offset, museumId: widget.museum.uid, query: query);
    };
    _fetchExhibition = ({int limit=10, int offset=0, String? query}) {
      return fetchAllTours(
        limit: limit, offset: offset, museumId: widget.museum.uid, isExhibition: true, query: query
      );
    };
    _fetchTour = ({int limit=10, int offset=0, String? query}) {
      return fetchAllTours(limit: limit, offset: offset, museumId: widget.museum.uid, query: query);
    };
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onArtworkPressed(AbstractListItem item){
    if (widget.useModal){
      showModal(
        context,
        (context) => FutureArtworkView(artwork: item as ArtworkListItem));
    } else {
      navigateToWidget(
        context,
        (context) => FutureArtworkView(artwork: item as ArtworkListItem),
      );
    }
  }

  void _onTourPressed(AbstractListItem item){
    final futureFuture = fetchTourById(item.uid!);
    if (widget.useModal){
      showModal(
        context,
        (context) => FutureTourView(tour: futureFuture));
    } else {
      navigateToWidget(
        context,
        (context) => FutureTourView(tour: futureFuture),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            widget.museum.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
          child: Text(
            widget.museum.descriptionText,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          )
        ),
        Center(
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: (){
              showModal(
                context,
                 (context) => ContentScrolling(
                    text: widget.museum.description,
                    edges: const EdgeInsets.all(15)
                  )
                );
            },
            child: const Text(
              'Voir plus',
              style: TextStyle(
                color: CupertinoColors.activeBlue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        CachedNetworkImage(
          imageUrl: widget.museum.image.path,
          width: double.infinity,
          fit: BoxFit.cover),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: 
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: CupertinoColors.systemGrey4,
                  onPressed: () {
                    // Action pour le bouton
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'images/icons/square_split_bottomrightquarter.png',
                        width: 24,
                        height: 24,
                        color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Plan du musée",
                        style: TextStyle(
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ],
                  ),
                )
              )
            ]
          )
        ),
        const SizedBox(height: 15),
        if (widget.museum.hasExhibitions)
          ContentBlock(
            title: 'Expositions',
            fetch: _fetchExhibition,
            onPressed: _onTourPressed,
            isModal: widget.useModal,
          ),
        if (widget.museum.hasCollection)
          ContentBlock(
            title: 'Collection',
            fetch: _fetchCollection,
            onPressed: _onArtworkPressed,
            isModal: widget.useModal,
          ),
        if (widget.museum.hasTours)
          ContentBlock(
            title: 'Visites',
            fetch: _fetchTour,
            onPressed: _onTourPressed,
            isModal: widget.useModal,
          ),
        const SizedBox(height: 35)
      ],
    );
  }
}
