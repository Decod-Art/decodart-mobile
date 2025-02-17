import 'package:decodart/ui/core/list/util/_util.dart' show OnPressList, SearchableDataFetcher;
import 'package:decodart/ui/core/list/util/controller.dart' show SearchableListController;
import 'package:decodart/data/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/ui/core/miscellaneous/error/error.dart' show ErrorView;
import 'package:decodart/ui/core/list/widgets/components/list_tile.dart' show ListTile;
import 'package:decodart/ui/core/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class SliverLazyListView<T extends AbstractListItem> extends StatefulWidget {
  final String title;
  final OnPressList<T> onPress;
  final SearchableDataFetcher<T> fetch;
  const SliverLazyListView({
    super.key,
    required this.title,
    required this.onPress,
    required this.fetch
  });
  
  @override
  State<StatefulWidget> createState() => SliverLazyListViewState<T>();
}

class SliverLazyListViewState<T extends AbstractListItem> extends State<SliverLazyListView<T>> {  
  late final SearchableListController<T> controller = SearchableListController<T>(widget.fetch);

  @override
  void initState() {
    super.initState();
    controller.addListener(checkIfNeedsLoading);
    updateView(250);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateView([int? duration]) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (duration != null) await Future.delayed(Duration(milliseconds: duration));
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

  int get nbElements => controller.length + (controller.isLoading ? 1 : 0) + (controller.failed ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: widget.title,
      controller: controller.scrollController,
      smallTitle: true,
      onSearch: (String value) {
        setState((){controller.query = value.isEmpty?null:value;});
        updateView();
      },
      childCount: nbElements,
      builder: (context, index) {
        if (controller.failed) {
          return Center(child: ErrorView(onPress: loadMoreItems));
        }
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
