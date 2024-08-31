import 'package:decodart/api/artwork.dart' show fetchArtworkById, fetchAllArtworks;
import 'package:decodart/api/tour.dart' show fetchAllTours, fetchTourById;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/tour/future_tour.dart' show FutureTourView;
import 'package:decodart/widgets/formatted_content/formatted_content_scrolling.dart' show ContentScrolling;
import 'package:decodart/widgets/list/horizontal_list_with_header.dart' show LazyHorizontalListWithHeader;
import 'package:decodart/widgets/list/lazy_list.dart' show LazyListWidget;
import 'package:decodart/widgets/modal/modal.dart' show ShowModal;
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;

class MuseumView extends StatefulWidget {
  final Museum museum;

  const MuseumView({
    super.key,
    required this.museum,
  });

  @override
  State<MuseumView> createState() => _MuseumViewState();
}

class _MuseumViewState extends State<MuseumView>  with ShowModal {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onArtworkPressed(AbstractListItem item){
    final futureArtwork = fetchArtworkById(item.uid!);
    showDecodModalBottomSheet(
      context,
      (context) => FutureArtworkView(artwork: futureArtwork),
      expand: true,
      useRootNavigator: true);
  }

  void _onTourPressed(AbstractListItem item){
    final futureFuture = fetchTourById(item.uid!);
    showDecodModalBottomSheet(
      context,
      (context) => FutureTourView(tour: futureFuture),
      expand: true,
      useRootNavigator: true);
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
              showDecodModalBottomSheet(
                context,
                (context) => ContentScrolling(
                  text: widget.museum.description,
                  edges: const EdgeInsets.all(15)),
                expand: true,
                useRootNavigator: true);
                
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
        if (widget.museum.hasExhibitions||true)
          LazyHorizontalListWithHeader(
            name: 'Visites',
            fetch: ({int limit=10, int offset=0}) {
              return fetchAllTours(limit: limit, offset: offset, museumId: widget.museum.uid, isExhibition: true);
            },
            onPressed: _onArtworkPressed,
            isMuseum: (item)=>false,
            onTitlePressed: (){
              showDecodModalBottomSheet(
                context,
                (context) => LazyListWidget(
                  fetch: ({int limit=10,int offset=0}) => fetchAllTours(limit: limit, offset: offset, museumId: widget.museum.uid, isExhibition: true),
                  onPress: _onArtworkPressed,
                ),
                expand: true,
                useRootNavigator: true,
                scroll: false);
            },
          ),
        if (widget.museum.hasCollection)
          LazyHorizontalListWithHeader(
            name: 'Collection',
            fetch: ({int limit=10, int offset=0}) {
              return fetchAllArtworks(limit: limit, offset: offset, museumId: widget.museum.uid);
            },
            onPressed: _onArtworkPressed,
            isMuseum: (item)=>false,
            onTitlePressed: (){
              showDecodModalBottomSheet(
                context,
                (context) => LazyListWidget(
                  fetch: ({int limit=10,int offset=0}) => fetchAllArtworks(limit: limit, offset: offset, museumId: widget.museum.uid),
                  onPress: _onArtworkPressed,
                ),
                expand: true,
                useRootNavigator: true,
                scroll: false);
            },
          ),
        if (widget.museum.hasTours)
          LazyHorizontalListWithHeader(
            name: 'Visites',
            fetch: ({int limit=10, int offset=0}) {
              return fetchAllTours(limit: limit, offset: offset, museumId: widget.museum.uid);
            },
            onPressed: _onArtworkPressed,
            isMuseum: (item)=>false,
            onTitlePressed: (){
              showDecodModalBottomSheet(
                context,
                (context) => LazyListWidget(
                  fetch: ({int limit=10,int offset=0}) => fetchAllTours(limit: limit, offset: offset, museumId: widget.museum.uid),
                  onPress: _onArtworkPressed,
                ),
                expand: true,
                useRootNavigator: true,
                scroll: false);
            },
          ),
        const SizedBox(height: 35)
        // Ajoutez d'autres widgets pour afficher les autres propriétés de l'artwork
      ],
    );
  }
}
