import 'package:decodart/controller_and_mixins/widgets/list/_util.dart' show OnError, SearchableFetch, LazyList, DataFetcher;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:flutter/cupertino.dart' show ScrollController, VoidCallback;

// Loading :
//  resetLoading
// await fetchMore
// can check if failed
// should reload when controller.shouldReload

abstract class AbstractListController<T extends AbstractListItem> {
  late final ScrollController _scrollController;
  bool _isLoading = false;
  bool _failedLoading = false;
  bool _firstTimeLoading = true;
  bool _retry = true;
  OnError? onError;
  static final int waitBeforeRetry = 5;

  AbstractListController({ScrollController? scrollController, this.onError})
    :_scrollController = scrollController??ScrollController();

  void resetLoading () {
    _isLoading = true;
    _failedLoading = false;
  }

  Future<void> _setFailed() async {
    _failedLoading = true;
    _isLoading = false;
    _retry = false;
    await Future.delayed(Duration(seconds: waitBeforeRetry));
    _retry = true;
  }

  void _completeLoading() {
    _failedLoading = false;
    _isLoading = false;
    _firstTimeLoading = false;
  }

  void beforeFetching(){}
  void afterCompleting(){}
  void afterFailing(){}

  Future<void> fetchMore() async {
    try {
      beforeFetching();
      await fetchMoreAPI();
      _completeLoading();
      afterCompleting();
    } catch (e, trace) {
      _setFailed();
      afterFailing();
      onError?.call(e, trace);
    }
  }

  bool get firstTimeLoading => _firstTimeLoading;

  bool get failed => _failedLoading;

  bool get canReload => (!failed||_retry)&&!_isLoading&&hasMore;

  bool get isLoading => _isLoading;

  bool get scrollReachedLimit => _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30;

  bool get shouldReload => scrollReachedLimit&&canReload;

  void removeListener(VoidCallback listener) {
    _scrollController.removeListener(listener);
  }

  void addListener(VoidCallback listener) {
    _scrollController.addListener(listener);
  }

  void dispose({bool disposeScrollController=true}) {
    if (disposeScrollController) {
      _scrollController.dispose();
    }
  }

  ScrollController get scrollController => _scrollController;

  // Abstract methods
  bool get hasMore;
  Future<void> fetchMoreAPI();
  int get length;
  List<T> get list;
  T get first;
  T get last;
  bool get isEmpty;
  bool get isNotEmpty;
  T operator [](int index);
  Iterator<T> get iterator;
}

class SearchableListController<T extends AbstractListItem> extends AbstractListController<T> {
  final SearchableFetch<T> fetch;
  late LazyList<T> items;

  bool _gotUpdated = false;

  SearchableListController(this.fetch, {super.scrollController, super.onError}) {
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
  Future<void> fetchMoreAPI() async {
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

class ListController<T extends AbstractListItem> extends AbstractListController<T> {
  final DataFetcher<T> fetch;
  late final LazyList<T> items;
  late List<T>? initial;

  ListController(this.fetch, {super.scrollController, this.initial, super.onError}) {
    items = LazyList<T>(fetch: fetch, initial: initial);
  }

  @override
  T operator [](int index) {
    return items[index];
  }

  @override
  Future<void> fetchMoreAPI() async {
    await items.fetchMore();
  }

  @override
  bool get shouldReload => (scrollReachedLimit)&&canReload;

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
}