import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/list/list_tile.dart' show ListTile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class LazyListWidget<T extends AbstractListItem> extends StatefulWidget {
  final List<T> items;
  final void Function(T) onPress;
  //final Future<void> Function() loadMoreItems;

  const LazyListWidget({
    super.key,
    required this.items,
    required this.onPress,
//    required this.loadMoreItems,
  });

  @override
  State<LazyListWidget<T>> createState() => _LazyListWidgetState<T>();
}

class _LazyListWidgetState<T extends AbstractListItem> extends State<LazyListWidget<T>> {
  late ScrollController _scrollController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        _loadMoreItems();
      }
    });
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      isLoading = true;
    });

    //await widget.loadMoreItems();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.items.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.items.length) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final item = widget.items[index];
        return Column(
          children: [
            if (index == 0) const SizedBox(height: 8),
            ListTile(item: item, onPress: widget.onPress),
            if (index != widget.items.length - 1)
              const Divider(
                indent: 80.0,
                color: CupertinoColors.separator,
              ),
            if (index == widget.items.length - 1) const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}