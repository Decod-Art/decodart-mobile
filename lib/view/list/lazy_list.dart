import 'package:decodart/api/util.dart' show LazyList;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/view/apropos/apropos.dart' show AproposView;
import 'package:decodart/widgets/list/list_tile.dart' show ListTile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;

class SliverLazyListView<T extends AbstractListItem> extends StatefulWidget {
  final String title;
  final void Function(T) onPress;
  final Future<List<T>> Function({int limit, int offset, String? query}) fetch;
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
  late ScrollController _scrollController;
  bool isLoading = false;
  bool _queryChanged = false;
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

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfNeedsLoading);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkIfNeedsLoading() async {
    if ((_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30||_queryChanged) && !isLoading && items.hasMore) {
      _queryChanged = false;
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
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Padding(
              padding: const EdgeInsets.only(right: 25, left: 5),
              child: CupertinoSearchTextField(
                placeholder: 'Rechercher',
                onChanged: (String value) {
                  _queryChanged = true;
                  items = LazyList<T>(fetch: ({limit=10, offset=0}){return widget.fetch(limit: limit, offset: offset, query: value.isEmpty?null:value);});
                  _checkIfNeedsLoading();
                },
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const AproposView()),
              );
              },
              child: const Icon(
                CupertinoIcons.person_circle,
                color: CupertinoColors.activeBlue,
                size: 24
              ),
            ),
            middle: const Text('Explorer')
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                childCount: items.length + (isLoading ? 1 : 0),
              ),
            ),
          )
        ]
      ),
    );
  }
}
