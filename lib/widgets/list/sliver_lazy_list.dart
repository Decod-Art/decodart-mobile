import 'package:decodart/controller_and_mixins/widgets/list/_util.dart' show OnPressList, SearchableFetch;
import 'package:decodart/controller_and_mixins/widgets/list/controller.dart' show SearchableListController;
import 'package:decodart/controller_and_mixins/widgets/list/mixin.dart' show ListMixin;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/component/error/error.dart' show ErrorView;
import 'package:decodart/widgets/list/util/list_tile.dart' show ListTile;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class SliverLazyListView<T extends AbstractListItem> extends StatefulWidget {
  final String title;
  final OnPressList<T> onPress;
  final SearchableFetch<T> fetch;
  final bool smallTitle;
  const SliverLazyListView({
    super.key,
    required this.title,
    required this.onPress,
    required this.fetch,
    this.smallTitle=false
  });
  
  @override
  State<StatefulWidget> createState() => SliverLazyListViewState<T>();
}

class SliverLazyListViewState<T extends AbstractListItem> extends State<SliverLazyListView<T>> with ListMixin {  
  @override
  late final SearchableListController<T> controller = SearchableListController<T>(widget.fetch);

  @override
  void initState() {
    super.initState();
    initMixin();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int get nbElements => controller.length + (controller.isLoading ? 1 : 0) + (controller.failed ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: widget.title,
      smallTitle: widget.smallTitle,
      controller: controller.scrollController,
      onSearch: (String value) {
        controller.query = value.isEmpty?null:value;
        checkIfNeedsLoading();
      },
      childCount: nbElements,
      builder: (context, index) {
        if (controller.failed) {
          return Center(
            child: ErrorView(onPress: loadMoreItems)
          );
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
