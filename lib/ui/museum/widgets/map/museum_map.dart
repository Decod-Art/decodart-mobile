import 'package:decodart/ui/museum/view_model/view_model.dart' show MuseumMapViewModel;
import 'package:decodart/data/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/data/model/museum.dart' show Museum;
import 'package:decodart/ui/artwork/widgets/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/ui/museum/widgets/map/pdf_map_viewer.dart' show FullScreenPDFViewer;
import 'package:decodart/ui/core/miscellaneous/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/ui/core/miscellaneous/error/error.dart' show ErrorView;
import 'package:decodart/ui/core/list/widgets/content_block/content_block.dart' show ContentBlock;
import 'package:decodart/ui/core/navigation/modal.dart' show showWidgetInModal;
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
  late final MuseumMapViewModel viewModel = MuseumMapViewModel(
    widget.museum,
    scrollController: widget.controller
  );
  @override
  void initState() {
    super.initState();
    viewModel.addListener(checkIfNeedsLoading);
    updateView(250);
  }

  @override
  void dispose() {
    viewModel.removeListener(checkIfNeedsLoading);
    viewModel.dispose();
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

  bool get showContent => (viewModel.isNotEmpty || viewModel.hasMore) && (!viewModel.failed||viewModel.firstTimeLoading);

  Future<void> checkIfNeedsLoading() async {
    if (viewModel.shouldReload) {
      loadMoreItems();
    }
  }

  Future<void> loadMoreItems() async {
    setState(() {
      viewModel.resetLoading();
    });   
    await viewModel.fetchMore();
    if (mounted){
      setState(() {});
      if (!viewModel.failed) {
        updateView();
      }
    }
  }

  Museum get museum => widget.museum;
  bool get hasMap => museum.hasMap;
  bool get isLoading => viewModel.isLoading;

  int get itemCount => viewModel.length + (isLoading ? 1 : 0) + (hasMap ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return viewModel.failed&&viewModel.firstTimeLoading
      ? ErrorView(onPress: loadMoreItems)
      : ListView.builder(
          controller: viewModel.scrollController,
          padding: EdgeInsets.only(bottom: 75),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final offset = hasMap ? -1 : 0 ;
            if (index == 0 && hasMap) {
              return ChevronButtonWidget(
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
              );
            } else if (index + offset == viewModel.length) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              return ContentBlock(
                title: "Salle ${viewModel[index+offset].name}",
                fetch: viewModel.fetchers[index+offset],
                initialValues: viewModel.initialValues[index+offset],
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