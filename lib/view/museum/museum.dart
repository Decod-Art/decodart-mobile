import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/tour.dart' show fetchAllTours;
import 'package:decodart/controller_and_mixins/widgets/list/_util.dart' show SearchableDataFetcher;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/view/museum/map/museum_map.dart' show MuseumMap;
import 'package:decodart/view/museum/map/museum_map_button.dart' show MuseumMapButton;
import 'package:decodart/widgets/component/formatted_content/content.dart' show ContentWidget;
import 'package:decodart/widgets/list/content_block/content_block.dart' show ContentBlock;
import 'package:decodart/widgets/list/util/item_type.dart' show ItemType;
import 'package:decodart/widgets/navigation/modal.dart' show showListInModal, showWidgetInModal;
import 'package:decodart/widgets/navigation/navigate_to_items.dart' show navigateToArtwork, navigateToTour;
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

class _MuseumViewState extends State<MuseumView>  {
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

  void _onMuseumMapPressed() {
      showListInModal(
        context,
        (context, [sc]) => MuseumMap(museum: widget.museum, isModal: widget.useModal, controller: sc,)
      );
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
              showWidgetInModal(
                context,
                 (context) => ContentWidget(
                    items: widget.museum.description,
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
          child: MuseumMapButton(onPressed: _onMuseumMapPressed)
        ),
        const SizedBox(height: 15),
        if (widget.museum.hasExhibitions)
          ContentBlock(
            title: 'Expositions',
            fetch: _fetchExhibition,
            itemType: (item) => ItemType.tour,
            onPressed: (item) => navigateToTour(item as TourListItem, context, modal: widget.useModal),
            isModal: widget.useModal,
          ),
        if (widget.museum.hasCollection)
          ContentBlock(
            title: 'Collection',
            fetch: _fetchCollection,
            onPressed: (item) => navigateToArtwork(item as ArtworkListItem, context, modal: widget.useModal),
            isModal: widget.useModal,
          ),
        if (widget.museum.hasTours)
          ContentBlock(
            title: 'Visites',
            fetch: _fetchTour,
            itemType: (item) => ItemType.tour,
            onPressed: (item) => navigateToTour(item as TourListItem, context, modal: widget.useModal),
            isModal: widget.useModal,
          ),
        const SizedBox(height: 35)
      ],
    );
  }
}
