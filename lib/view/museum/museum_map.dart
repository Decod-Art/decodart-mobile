import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/room.dart' show fetchRooms;
import 'package:decodart/api/util.dart' show LazyList, SearchableDataFetcher;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/museum.dart' show Museum, MuseumForeignKey;
import 'package:decodart/model/room.dart' show RoomListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/map_viewer.dart' show FullScreenPDFViewer;
import 'package:decodart/widgets/buttons/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/new/list/content_block.dart' show ContentBlock;
import 'package:decodart/widgets/new/navigation/modal.dart' show showWidgetInModal;
import 'package:flutter/cupertino.dart';

class MuseumMap extends StatefulWidget {
  final bool isModal;
  final Museum museum;
  final String? museumMapPath;
  final ScrollController? controller;

  const MuseumMap({
    super.key,
    this.museumMapPath,
    required this.museum,
    required this.isModal,
    this.controller
  });
  
  @override
  State<MuseumMap> createState() => _MuseumMapState();
}

class _MuseumMapState extends State<MuseumMap> {
  late ScrollController _scrollController;
  late LazyList<RoomListItem> items;
  List<SearchableDataFetcher<ArtworkListItem>> fetchers = [];
  List<List<ArtworkListItem>> initialValues = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    items = LazyList<RoomListItem>(fetch: _fetchRooms, limit: 5);
    _scrollController = widget.controller??ScrollController();
    _scrollController.addListener(_checkIfNeedsLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfNeedsLoading();
    });
  }

  Future<void> _checkIfNeedsLoading() async {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30 && !_isLoading && items.hasMore) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      _isLoading = true;
    });

    await items.fetchMore();
    for (int i = fetchers.length ; i < items.length ; i++) {
      fetchers.add(
        ({int limit=10, int offset=0, String? query}) {
          return fetchAllArtworks(limit: limit, offset: offset, museumId: widget.museum.uid, room: items[i].name, query: query);
        }
      );
      // Initial values to avoid calling multiple times the API.. while we have a set of artworks already loaded.
      initialValues.add(
        items[i].artworks
      );
    }

    // Appeler la fonction pour charger plus d'éléments
    //await widget.loadMoreItems();
    if (mounted){
      setState(() {
        _isLoading = false;
      });
      _checkIfNeedsLoading();
    }
  }

  Future<List<RoomListItem>> _fetchRooms({int limit=5, int offset=0}) async {
    return fetchRooms(museum: MuseumForeignKey(name: widget.museum.name, uid: widget.museum.uid), limit: limit, offset: offset);
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length + (_isLoading ? 2 : 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const SizedBox(height: 15),
              ChevronButtonWidget(
                // https://museefabre-old.montpellier3m.fr/content/download/12182/92171/version/2/file/Musee_Fabre-Plans.pdf
                text: "Voir le plan du musée",
                subtitle: 'Document pdf',
                icon: const Icon(
                  CupertinoIcons.doc,
                  color: CupertinoColors.activeBlue,
                ),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      builder: (context) => FullScreenPDFViewer(
                        pdfUrl: widget.museumMapPath ?? 'https://api-www.louvre.fr/sites/default/files/2022-03/LOUVRE_PlanG-2022-FR_0.pdf',
                      ),
                    ),
                  );
                },
              ),
            ]
          );
        } else if (index == items.length+1) {
          return const Center(child: CupertinoActivityIndicator());
        } else {
          return ContentBlock(
            title: "Salle ${items[index-1].name}",
            fetch: fetchers[index-1],
            initialValues: initialValues[index-1],
            onPressed: (artwork){
              showWidgetInModal(
                context,
                (context) => FutureArtworkView(artwork: artwork as ArtworkListItem),
              );
            },
            isModal: true,
          );
        }
      }
    );
  }
}