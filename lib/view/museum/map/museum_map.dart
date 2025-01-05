import 'package:decodart/controller_and_mixins/museum/map/controller.dart' show MuseumMapController;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/map/pdf_map_viewer.dart' show FullScreenPDFViewer;
import 'package:decodart/widgets/component/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/component/error/error.dart' show ErrorView;
import 'package:decodart/widgets/list/content_block/content_block.dart' show ContentBlock;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;
import 'package:flutter/cupertino.dart';

class MuseumMap extends StatefulWidget {
  final bool isModal;
  final Museum museum;
  final ScrollController? controller;

  const MuseumMap({
    super.key,
    required this.museum,
    required this.isModal,
    this.controller
  });
  
  @override
  State<MuseumMap> createState() => _MuseumMapState();
}

class _MuseumMapState extends State<MuseumMap>  {
  late final MuseumMapController controller = MuseumMapController(
    widget.museum,
    scrollController: widget.controller
  );
  @override
  void initState() {
    super.initState();
    controller.addListener(checkIfNeedsLoading);
    updateView(250);
  }

  @override
  void dispose() {
    controller.removeListener(checkIfNeedsLoading);
    controller.dispose();
    super.dispose();
  }

  void updateView([int? duration]) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (duration != null){
        await Future.delayed(Duration(milliseconds: duration));
      }
      checkIfNeedsLoading();
    });
  }

  bool get showContent => (controller.isNotEmpty || controller.hasMore) && (!controller.failed||controller.firstTimeLoading);

  Future<void> checkIfNeedsLoading() async {
    if (controller.shouldReload) {
      loadMoreItems();
    }
  }

  Future<void> loadMoreItems() async {
    setState(() {
      controller.resetLoading();
    });   
    await controller.fetchMore();
    if (mounted){
      setState(() {});
      if (!controller.failed) {
        updateView();
      }
    }
  }

  Museum get museum => widget.museum;
  bool get hasMap => museum.hasMap;
  bool get isLoading => controller.isLoading;

  int get itemCount => controller.length + (isLoading ? 1 : 0) + (hasMap ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return controller.failed&&controller.firstTimeLoading
      ? ErrorView(onPress: loadMoreItems)
      : ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.length + (controller.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            final offset = hasMap ? -1 : 0 ;
            if (index == 0 && hasMap) {
              return Column(
                children: [
                  const SizedBox(height: 15),
                  ChevronButtonWidget(
                    text: "Voir le plan du musée",
                    subtitle: 'Document pdf',
                    icon: const Icon(
                      CupertinoIcons.doc,
                      color: CupertinoColors.activeBlue,
                    ),
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(builder: (context) => FullScreenPDFViewer(pdf: museum.pdfMap,)),
                      );
                    },
                  ),
                ]
              );
            } else if (index + offset == controller.length) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              return ContentBlock(
                title: "Salle ${controller[index+offset].name}",
                fetch: controller.fetchers[index+offset],
                initialValues: controller.initialValues[index+offset],
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