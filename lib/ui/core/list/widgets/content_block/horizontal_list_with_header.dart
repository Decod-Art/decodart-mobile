import 'package:decodart/ui/core/list/util/_util.dart' show DataFetcher, OnPressList;
import 'package:decodart/ui/core/list/util/controller.dart' show ListController;
import 'package:decodart/data/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/ui/core/miscellaneous/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/ui/core/miscellaneous/image/thumbnail.dart' show ThumbnailWidget;
import 'package:decodart/ui/core/list/widgets/components/item_type.dart';
import 'package:flutter/cupertino.dart';

class LazyHorizontalListWithHeader<T extends AbstractListItem> extends StatefulWidget {
  final String name;
  final DataFetcher<T> fetch;
  final OnPressList onPressed;
  final VoidCallback onTitlePressed;
  final void Function(Object, StackTrace)? onError;
  final ItemType Function(T) itemType;
  final List<T> initialValues;
  final bool loadingDelay;
  const LazyHorizontalListWithHeader({
    super.key,
    required this.name,
    required this.fetch,
    required this.onPressed,
    required this.itemType,
    required this.onTitlePressed,
    this.initialValues = const [],
    this.onError,
    this.loadingDelay=false
    });
    
    @override
    State<LazyHorizontalListWithHeader<T>> createState() => LazyHorizontalListWithHeaderState<T>();
}

class LazyHorizontalListWithHeaderState<T extends AbstractListItem> extends State<LazyHorizontalListWithHeader<T>> {
  final ScrollController scrollController = ScrollController();
  late ListController<T> controller;

  @override
  void initState() {
    super.initState();
    initListController();
  }

  void initListController() {
    controller = ListController<T>(
      widget.fetch,
      initial: widget.initialValues,
      onError: widget.onError,
      scrollController: scrollController
    );
    controller.addListener(checkIfNeedsLoading);
    updateView(widget.loadingDelay ? 250 : null);
  }

  @override
  void didUpdateWidget(covariant LazyHorizontalListWithHeader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fetch != widget.fetch) {
      controller.removeListener(checkIfNeedsLoading);
      controller.dispose();
      setState(() {initListController();});
    }
  }

  void updateView([int? duration]) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (duration != null){
        await Future.delayed(Duration(milliseconds: duration));
      }
      checkIfNeedsLoading();
    });
  }

  bool get showContent => controller.isNotEmpty || (controller.hasMore && !controller.failed);

  Future<void> checkIfNeedsLoading() async {
    if (controller.shouldReload) loadMoreItems();
  }

  Future<void> loadMoreItems() async {
    setState(() {controller.resetLoading();});   
    await controller.fetchMore();
    if (mounted){
      setState(() {});
      if (!controller.failed) {
        updateView();
      }
    }
  }

  @override
  void dispose() {
    controller.removeListener(checkIfNeedsLoading);
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showContent) ... [
          ChevronButtonWidget(
            text: widget.name,
            fontWeight: FontWeight.w500,
            fontSize: 22,
            chevronColor: CupertinoColors.activeBlue,
            marginRight: 20,
            onPressed: widget.onTitlePressed,
          ),
          SizedBox(
            height: 250, // Ajustez la hauteur selon vos besoins
            child: controller.firstTimeLoadingAndNotFailed
              ? const Center(child: CupertinoActivityIndicator())
              : ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.length + (controller.isLoading?1:0),
                  itemBuilder: (context, index) {
                    if (index != controller.length){
                      final item = controller[index];
                      return ThumbnailWidget(
                          title: item.title,
                          image: item.image,
                          itemType: widget.itemType(item),
                          onPressed: (){widget.onPressed(item);}
                        );
                    } else {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                  },
                ),
          ),
        ]
    ],
  );
  }
}