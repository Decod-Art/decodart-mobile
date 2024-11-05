import 'package:decodart/api/util.dart' show LazyList;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/list/util/list_tile.dart' show ListTile;
import 'package:decodart/widgets/new/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;


typedef OnPressList<T> = void Function(T);
typedef SearchableFetch<T> = Future<List<T>> Function({int limit, int offset, String? query});

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

class SliverLazyListViewState<T extends AbstractListItem> extends State<SliverLazyListView<T>> {
  late ScrollController _scrollController;
  bool isLoading = false;
  bool firstTimeLoading = true;
  bool _queryChanged = false;
  late LazyList<T> items;

  @override
  void initState() {
    super.initState();
    items = LazyList<T>(fetch: widget.fetch);
    _scrollController = ScrollController();
    _scrollController.addListener(_checkIfNeedsLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 250));
      _checkIfNeedsLoading();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfNeedsLoading);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkIfNeedsLoading() async {
    if (((_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30||_queryChanged) && !isLoading && items.hasMore)||firstTimeLoading) {
      _queryChanged = false;
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      isLoading = true;
    });
    await items.fetchMore();
    if (mounted){
      setState(() {
        isLoading = false;
        firstTimeLoading = false;
      });
      _checkIfNeedsLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: widget.title,
      smallTitle: widget.smallTitle,
      controller: _scrollController,
      onSearch: (String value) {
        _queryChanged = true;
        items = LazyList<T>(fetch: ({limit=10, offset=0}){return widget.fetch(limit: limit, offset: offset, query: value.isEmpty?null:value);});
        _checkIfNeedsLoading();
      },
      childCount: items.length + (isLoading ? 1 : 0),
      builder: (context, index) {
        if (index == items.length) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final item = items[index];
        return Column(
          children: [
            if (index == 0) const SizedBox(height: 8),
            ListTile(item: item, onPress: widget.onPress),
            if (index != items.length - 1)
              const Divider(
                indent: 80.0,
                color: CupertinoColors.separator,
              ),
            if (index == items.length - 1) const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
