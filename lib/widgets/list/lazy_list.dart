import 'package:decodart/controller/widgets/list_controller/_util.dart' show DataFetcher, LazyList;
import 'package:decodart/controller/widgets/list_controller/controller.dart' show ListController;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/component/error/error.dart' show ErrorView;
import 'package:decodart/widgets/list/util/list_tile.dart' show ListTile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class LazyListWidget<T extends AbstractListItem> extends StatefulWidget {
  final DataFetcher<T> fetch;
  final ScrollController? controller;
  final void Function(T) onPress;
  //final Future<void> Function() loadMoreItems;

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
  late final ListController<T> _listController = ListController<T>(
    widget.fetch,
    scrollController: widget.controller
  );

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
    _listController.removeListener(_checkIfNeedsLoading);
    _listController.dispose(
      disposeScrollController: widget.controller == null
    );
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

  int get nbElements => _listController.length + (_listController.isLoading ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return _listController.failed&&_listController.firstTimeLoading
      ? ErrorView(onPress: _loadMoreItems)
      : ListView.builder(
          controller: _listController.scrollController,
          itemCount: nbElements,
          itemBuilder: (context, index) {
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