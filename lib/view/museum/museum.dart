import 'package:decodart/api/artwork.dart' show fetchArtworkById, fetchArtworkByMuseum;
import 'package:decodart/api/tour.dart' show fetchTourByMuseum, fetchExhibitionByMuseum;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/model/artwork.dart' show Artwork, ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/widgets/buttons/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/formatted_content/formatted_content_scrolling.dart' show ContentScrolling;
import 'package:decodart/widgets/image/thumbnail.dart' show ThumbnailWidget;
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
  List<TourListItem> tours = [];
  List<TourListItem> exhibition = [];
  List<ArtworkListItem> collection = [];

  final ScrollController _scrollController = ScrollController();
  bool _showTopLine = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchTours();
    _fetchExhibition();
    _fetchCollection();
  }

  Future<void> _fetchTours() async {
    tours.addAll(await fetchTourByMuseum(widget.museum.uid!));
    setState(() {});
  }

  Future<void> _fetchExhibition() async {
    exhibition.addAll(await fetchExhibitionByMuseum(widget.museum.uid!));
    setState(() {});
  }

  Future<void> _fetchCollection() async {
    collection.addAll(await fetchArtworkByMuseum(widget.museum.uid!));
    setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.position.pixels > 0) {
      if (!_showTopLine) {
        setState(() {
          _showTopLine = true;
        });
      }
    } else {
      if (_showTopLine) {
        setState(() {
          _showTopLine = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
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
        if (widget.museum.hasExhibitions)
          ..._rowOfItems(context, 'Expositions', exhibition, (item){}),
        if (widget.museum.hasCollection)
          ..._rowOfItems(
            context,
            'Collection',
            collection,
            (item) {
              showDecodModalBottomSheet(
                context,
                (context) => FutureArtworkView(artwork: item),
                expand: true,
                useRootNavigator: true);
            }),
        if (widget.museum.hasTours)
          ..._rowOfItems(context, 'Visites', tours, (item){}),
        const SizedBox(height: 35)
        // Ajoutez d'autres widgets pour afficher les autres propriétés de l'artwork
      ],
    );
  }

  List<Widget> _rowOfItems(BuildContext context, String name, List<AbstractListItem> items, FutureItemCallback onPressed) {
    return [ChevronButtonWidget(
      text: name,
      fontWeight: FontWeight.w500,
      fontSize: 22,
      chevronColor: CupertinoColors.activeBlue,
      marginRight: 20,
      onPressed: (){},),
      if (items.isEmpty)
        const Center(
          child: CupertinoActivityIndicator(),
        )
      else
        SizedBox(
          height: 250, // Ajustez la hauteur selon vos besoins
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ThumbnailWidget(
                title: item.title,
                image: item.image,
                onPressed: (){onPressed(fetchArtworkById(item.uid!));}
              );
            },
          ),
        )];
  }
}

typedef FutureItemCallback = void Function(Future<Artwork>);