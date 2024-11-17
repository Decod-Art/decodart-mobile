import 'package:decodart/controller/museum/map/controller.dart';
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/map_viewer.dart' show FullScreenPDFViewer;
import 'package:decodart/widgets/component/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/component/error/error.dart';
import 'package:decodart/widgets/list/content_block.dart' show ContentBlock;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;
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
  late final MuseumMapController _mapController = MuseumMapController(
    widget.museum,
    scrollController: widget.controller
  );
  @override
  void initState() {
    super.initState();
    _mapController.addListener(_checkIfNeedsLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfNeedsLoading();
    });
  }

  @override
  void dispose() {
    _mapController.dispose(disposeScrollController: widget.controller==null);
    super.dispose();
  }

  Future<void> _checkIfNeedsLoading() async {
    if (_mapController.shouldReload) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      _mapController.resetLoading();
    });

    await _mapController.fetchMore();
    if (mounted){
      setState(() {});
      if (!_mapController.failed) {
        _checkIfNeedsLoading();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _mapController.failed&&_mapController.firstTimeLoading
      ? ErrorView(onPress: _loadMoreItems)
      : ListView.builder(
          controller: _mapController.scrollController,
          itemCount: _mapController.length + (_mapController.isLoading ? 2 : 1),
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
            } else if (index == _mapController.length+1) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              return ContentBlock(
                title: "Salle ${_mapController[index-1].name}",
                fetch: _mapController.fetchers[index-1],
                initialValues: _mapController.initialValues[index-1],
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