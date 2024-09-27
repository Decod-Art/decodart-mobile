import 'package:decodart/api/util.dart' show DataFetcher, LazyList;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/buttons/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/image/thumbnail.dart' show ThumbnailWidget;
import 'package:flutter/cupertino.dart';

class LazyHorizontalListWithHeader<T extends AbstractListItem> extends StatefulWidget {
  final String name;
  final DataFetcher<T> fetch;
  final AbstractListItemCallback onPressed;
  final VoidCallback onTitlePressed;
  final bool Function(T) isMuseum;
  const LazyHorizontalListWithHeader({
    super.key,
    required this.name,
    required this.fetch,
    required this.onPressed,
    required this.isMuseum,
    required this.onTitlePressed
    });
    
      @override
      State<LazyHorizontalListWithHeader<T>> createState() => LazyHorizontalListWithHeaderState<T>();
}

class LazyHorizontalListWithHeaderState<T extends AbstractListItem> extends State<LazyHorizontalListWithHeader<T>> {
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

  @override
  void didUpdateWidget(covariant LazyHorizontalListWithHeader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fetch != widget.fetch) {
      setState(() {
        items = LazyList<T>(fetch: widget.fetch);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkIfNeedsLoading();
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfNeedsLoading);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkIfNeedsLoading() async {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30 && !isLoading && items.hasMore) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      isLoading = true;
    });
    await items.fetchMore();
    setState(() {
      isLoading = false;
    });
    _checkIfNeedsLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (items.isNotEmpty || items.hasMore) ... [
          ChevronButtonWidget(
            text: widget.name,
            fontWeight: FontWeight.w500,
            fontSize: 22,
            chevronColor: CupertinoColors.activeBlue,
            marginRight: 20,
            onPressed: widget.onTitlePressed,
          ),
          SizedBox(
            height: 250, // Ajustez la hauteur selon vos besoins
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: items.length + (isLoading?1:0),
              itemBuilder: (context, index) {
                if (index != items.length){
                  final item = items[index];
                  return ThumbnailWidget(
                      title: item.title,
                      image: item.image,
                      isMuseum: widget.isMuseum(item),
                      onPressed: (){widget.onPressed(item);}
                    );
                } else {
                  return const Center(child: CupertinoActivityIndicator());
                }
              },
            ),
          ),
        ]
    ],
  );
  }
}

typedef AbstractListItemCallback = void Function(AbstractListItem);