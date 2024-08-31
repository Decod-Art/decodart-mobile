import 'package:decodart/api/util.dart';
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/list/list_tile.dart' show ListTile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class LazyListWidget<T extends AbstractListItem> extends StatefulWidget {
  final DataFetcher<T> fetch;
  final void Function(T) onPress;
  //final Future<void> Function() loadMoreItems;

  const LazyListWidget({
    super.key,
    required this.fetch,
    required this.onPress,
  });

  @override
  State<LazyListWidget<T>> createState() => _LazyListWidgetState<T>();
}

class _LazyListWidgetState<T extends AbstractListItem> extends State<LazyListWidget<T>> {
  late ScrollController _scrollController;
  bool isLoading = false;
  late LazyList<T> items;

  @override
  void initState() {
    super.initState();
    items = LazyList<T>(fetch: widget.fetch);
    _scrollController = ScrollController();
    _scrollController.addListener(_checkIfNeedsLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfNeedsLoading();
    });
  }

  Future<void> _checkIfNeedsLoading() async {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30 && !isLoading && items.hasMore) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    print('loading...');
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
      });
      _checkIfNeedsLoading();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfNeedsLoading);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
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
      )
    );
  }
}