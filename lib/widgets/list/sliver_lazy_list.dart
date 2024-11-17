import 'package:decodart/controller/widgets/list_controller.dart' show SearchableListController;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/component/error/error.dart';
import 'package:decodart/widgets/list/util/list_tile.dart' show ListTile;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
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
  late final SearchableListController<T> _listController = SearchableListController<T>(widget.fetch);

  @override
  void initState() {
    super.initState();
    _listController.addListener(_checkIfNeedsLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 250));
      _checkIfNeedsLoading();
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  Future<void> _checkIfNeedsLoading() async {
    if (_listController.shouldReload) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      _listController.resetLoading();
    });
    await _listController.fetchMore();
    if (mounted){
      setState(() {});
      if (!_listController.failed) {
        _checkIfNeedsLoading();
      }
    }
  }

  int get nbElements => _listController.length + (_listController.isLoading ? 1 : 0) + (_listController.failed ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: widget.title,
      smallTitle: widget.smallTitle,
      controller: _listController.scrollController,
      onSearch: (String value) {
        _listController.query = value.isEmpty?null:value;
        _checkIfNeedsLoading();
      },
      childCount: nbElements,
      builder: (context, index) {
        if (_listController.failed) {
          return Center(
            child: ErrorView(onPress: _loadMoreItems)
          );
        }
        if (index == _listController.length) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final item = _listController[index];
        return Column(
          children: [
            if (index == 0) const SizedBox(height: 8),
            ListTile(item: item, onPress: widget.onPress),
            if (index != _listController.length - 1)
              const Divider(
                indent: 80.0,
                color: CupertinoColors.separator,
              ),
            if (index == _listController.length - 1) const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
