import 'package:decodart/util/online.dart';
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
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
  late ScrollController _scrollController;
  bool isLoading = true;
  bool firstTimeLoading = true;
  late LazyList<T> items;

  @override
  void initState() {
    super.initState();
    items = LazyList<T>(fetch: widget.fetch);
    _scrollController = widget.controller??ScrollController();
    _scrollController.addListener(_checkIfNeedsLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 250));
      _checkIfNeedsLoading();
    });
  }

  Future<void> _checkIfNeedsLoading() async {
    if ((_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30 && !isLoading && items.hasMore) || firstTimeLoading) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      isLoading = true;
    });

    // Simuler un délai de 2 secondes
    await items.fetchMore();

    // Appeler la fonction pour charger plus d'éléments
    //await widget.loadMoreItems();
    if (mounted){
      setState(() {
        isLoading = false;
        firstTimeLoading = false;
      });
      _checkIfNeedsLoading();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfNeedsLoading);
    if (widget.controller == null){
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
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