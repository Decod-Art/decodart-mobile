import 'package:decodart/controller_and_mixins/museum/map/controller.dart' show MuseumMapController;
import 'package:decodart/controller_and_mixins/widgets/list/mixin.dart' show ListMixin;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/view/museum/map/pdf_map_viewer.dart' show FullScreenPDFViewer;
import 'package:decodart/widgets/component/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/component/error/error.dart' show ErrorView;
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

class _MuseumMapState extends State<MuseumMap>  with ListMixin {
  @override
  late final MuseumMapController controller = MuseumMapController(
    widget.museum,
    scrollController: widget.controller
  );
  @override
  void initState() {
    super.initState();
    initMixin();
  }

  @override
  void dispose() {
    controller.dispose(disposeScrollController: widget.controller==null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.failed&&controller.firstTimeLoading
      ? ErrorView(onPress: loadMoreItems)
      : ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.length + (controller.isLoading ? 2 : 1),
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
            } else if (index == controller.length+1) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              return ContentBlock(
                title: "Salle ${controller[index-1].name}",
                fetch: controller.fetchers[index-1],
                initialValues: controller.initialValues[index-1],
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