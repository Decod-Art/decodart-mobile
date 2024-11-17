import 'package:decodart/controller/widgets/list_controller/_util.dart' show DataFetcher, LazyList;
import 'package:decodart/controller/widgets/list_controller/controller.dart' show ListController;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/component/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/component/image/thumbnail.dart' show ThumbnailWidget;
import 'package:flutter/cupertino.dart';

class LazyHorizontalListWithHeader<T extends AbstractListItem> extends StatefulWidget {
  final String name;
  final DataFetcher<T> fetch;
  final AbstractListItemCallback onPressed;
  final VoidCallback onTitlePressed;
  final void Function(Object, StackTrace)? onError;
  final bool Function(T) isMuseum;
  final List<T> initialValues;
  const LazyHorizontalListWithHeader({
    super.key,
    required this.name,
    required this.fetch,
    required this.onPressed,
    required this.isMuseum,
    required this.onTitlePressed,
    this.initialValues = const [],
    this.onError
    });
    
      @override
      State<LazyHorizontalListWithHeader<T>> createState() => LazyHorizontalListWithHeaderState<T>();
}

class LazyHorizontalListWithHeaderState<T extends AbstractListItem> extends State<LazyHorizontalListWithHeader<T>> {
  late ListController<T> _listController = ListController<T>(
    widget.fetch,
    initial: widget.initialValues,
    onError: widget.onError
  );

  // late ScrollController _scrollController;
  // bool isLoading = false;
  // bool error = false;
  // late LazyList<T> items;

  @override
  void initState() {
    super.initState();
    _listController.addListener(_checkIfNeedsLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkIfNeedsLoading();
    });
  }

  @override
  void didUpdateWidget(covariant LazyHorizontalListWithHeader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fetch != widget.fetch) {
      setState(() {
        _listController = ListController<T>(
          widget.fetch,
          initial: widget.initialValues,
          onError: widget.onError
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkIfNeedsLoading();
        });
      });
    }
  }

  @override
  void dispose() {
    _listController.removeListener(_checkIfNeedsLoading);
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

  bool get showContent => (_listController.isNotEmpty || _listController.hasMore) && !(_listController.failed&&_listController.firstTimeLoading);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showContent) ... [
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
              controller: _listController.scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _listController.length + (_listController.isLoading?1:0),
              itemBuilder: (context, index) {
                if (index != _listController.length){
                  final item = _listController[index];
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