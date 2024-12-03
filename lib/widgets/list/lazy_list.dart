import 'package:decodart/controller_and_mixins/widgets/list/_util.dart' show DataFetcher;
import 'package:decodart/controller_and_mixins/widgets/list/controller.dart' show ListController;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/component/error/error.dart' show ErrorView;
import 'package:decodart/widgets/list/util/list_tile.dart' show ListTile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class LazyListWidget<T extends AbstractListItem> extends StatefulWidget {
  final DataFetcher<T> fetch;
  final ScrollController? controller;
  final void Function(T) onPress;

  const LazyListWidget({
    super.key,
    required this.fetch,
    required this.onPress,
    this.controller
  });

  @override
  State<LazyListWidget<T>> createState() => _LazyListWidgetState<T>();
}

class _LazyListWidgetState<T extends AbstractListItem> extends State<LazyListWidget<T>> {
  late final ListController<T> controller = ListController<T>(widget.fetch, scrollController: widget.controller);

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
    setState(() {controller.resetLoading();});   
    await controller.fetchMore();
    if (mounted){
      setState(() {});
      if (!controller.failed) {
        updateView();
      }
    }
  }

  int get nbElements => controller.length + (controller.isLoading ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return controller.failed&&controller.firstTimeLoading
      ? ErrorView(onPress: loadMoreItems)
      : ListView.builder(
          controller: controller.scrollController,
          itemCount: nbElements,
          itemBuilder: (context, index) {
            if (index == controller.length) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final item = controller[index];
            return Column(
              children: [
                if (index == 0) const SizedBox(height: 8),
                ListTile(item: item, onPress: widget.onPress),
                if (index != controller.length - 1)
                  const Divider(
                    indent: 80.0,
                    color: CupertinoColors.separator,
                  ),
                if (index == controller.length - 1) const SizedBox(height: 8),
              ],
            );
          },
        );
  }
}