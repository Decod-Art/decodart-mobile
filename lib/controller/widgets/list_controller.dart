import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/util/online.dart' show LazyList;
import 'package:decodart/widgets/list/sliver_lazy_list.dart' show SearchableFetch;
import 'package:flutter/cupertino.dart' show ScrollController, VoidCallback;

abstract class _ListController<T> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _failedLoading = false;
  bool _firstTimeLoading = true;

  void resetLoading () {
    _isLoading = true;
    _failedLoading = false;
  }

  void _setFailed() {
    _failedLoading = true;
    _isLoading = false;
  }

  void _completeLoading() {
    _failedLoading = false;
    _isLoading = false;
    _firstTimeLoading = false;
  }

  Future<void> fetchMore() async {
    try {
      // Simuler un délai de 2 secondes
      await _fetchMore();
      _completeLoading();
    } catch (_, __) {
      _setFailed();
    }
  }

  bool get firstTimeLoading => _firstTimeLoading;

  bool get failed => _failedLoading;

  bool get canReload => !failed&&!_isLoading&&hasMore;

  bool get isLoading => _isLoading;

  bool get scrollReachedLimit => _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30;

  bool get shouldReload => scrollReachedLimit&&canReload;

  void removeListener(VoidCallback listener) {
    _scrollController.removeListener(listener);
  }

  void addListener(VoidCallback listener) {
    _scrollController.addListener(listener);
  }

  void dispose() {
    _scrollController.dispose();
  }

  ScrollController get scrollController => _scrollController;

  // Abstract methods
  bool get hasMore;
  Future<void> _fetchMore();
  int get length;
  List<T> get list;
  T get first;
  T get last;
  bool get isEmpty;
  bool get isNotEmpty;
  T operator [](int index);
  Iterator<T> get iterator;
}

class SearchableListController<T extends AbstractListItem> extends _ListController<T> {
  final SearchableFetch<T> fetch;
  late LazyList<T> items;

  bool _gotUpdated = false;

  SearchableListController(this.fetch) {
    items = LazyList<T>(fetch: fetch);
  }

  set query(String? query) {
    _gotUpdated = true;
    items = LazyList<T>(
      fetch: ({limit=10, offset=0}){
        return fetch(limit: limit, offset: offset, query: query);
      }
    );
  }

  @override
  T operator [](int index) {
    return items[index];
  }

  @override
  Future<void> _fetchMore() async {
    await items.fetchMore();
  }

  @override
  bool get shouldReload => (scrollReachedLimit||hasBeenUpdated)&&canReload;

  @override
  T get first => items.first;

  @override
  bool get hasMore => items.hasMore;

  @override
  bool get isEmpty => items.isEmpty;

  @override
  bool get isNotEmpty => items.isNotEmpty;

  @override
  Iterator<T> get iterator => items.iterator;

  @override
  T get last => items.last;

  @override
  int get length => items.length;

  @override
  List<T> get list => items.list;

  bool get hasBeenUpdated {
    final currentVal = _gotUpdated;
    _gotUpdated = false;
    return currentVal;
  }
  
}