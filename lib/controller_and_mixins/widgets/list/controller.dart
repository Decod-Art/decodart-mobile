import 'package:decodart/controller_and_mixins/widgets/list/_util.dart' show OnError, SearchableDataFetcher, LazyList, DataFetcher;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:flutter/cupertino.dart' show ScrollController, VoidCallback;

/// Abstract controller for managing a list with lazy loading and error handling.
abstract class AbstractListController<T> {
  late final ScrollController _scrollController;
  late final bool shouldDisposeController;
  bool _isLoading = false;
  bool _failedLoading = false;
  bool _firstTimeLoading = true;
  bool _retry = true;
  OnError? onError;
  static final int waitBeforeRetry = 5;

  /// Creates an [AbstractListController] with an optional [scrollController] and [onError] callback.
  AbstractListController({ScrollController? scrollController, this.onError})
      : _scrollController = scrollController ?? ScrollController(),
        shouldDisposeController = scrollController == null;

  /// Resets the loading state.
  void resetLoading() {
    _isLoading = true;
    _failedLoading = false;
  }

  /// Sets the loading state to failed and waits before retrying.
  Future<void> _setFailed() async {
    _failedLoading = true;
    _isLoading = false;
    _retry = false;
    await Future.delayed(Duration(seconds: waitBeforeRetry));
    _retry = true;
  }

  /// Completes the loading state.
  void _completeLoading() {
    _failedLoading = false;
    _isLoading = false;
    _firstTimeLoading = false;
  }

  /// Called before fetching data.
  void beforeFetching() {}

  /// Called after completing data fetch.
  void afterCompleting() {}

  /// Called after failing to fetch data.
  void afterFailing() {}

  /// Fetches more data and updates the loading state.
  Future<void> fetchMore() async {
    try {
      beforeFetching();
      await fetchMoreAPI();
      _completeLoading();
      afterCompleting();
    } catch (e, trace) {
      await _setFailed();
      afterFailing();
      onError?.call(e, trace);
    }
  }

  /// Returns whether it is the first time loading.
  bool get firstTimeLoading => _firstTimeLoading;

  /// Returns whether the loading has failed.
  bool get failed => _failedLoading;

  /// Returns whether it is the first time loading and not failed.
  bool get firstTimeLoadingAndNotFailed => !failed && firstTimeLoading;

  /// Returns whether the controller can reload.
  bool get canReload => (!failed || _retry) && !_isLoading && hasMore;

  /// Returns whether the controller is loading.
  bool get isLoading => _isLoading;

  /// Returns whether the scroll has reached the limit.
  bool get scrollReachedLimit {
    if (_scrollController.hasClients) {
      return _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30;
    }
    return false;
  }

  /// Returns whether the controller should reload.
  bool get shouldReload => scrollReachedLimit && canReload;

  /// Removes a listener from the scroll controller.
  void removeListener(VoidCallback listener) {
    _scrollController.removeListener(listener);
  }

  /// Adds a listener to the scroll controller.
  void addListener(VoidCallback listener) {
    _scrollController.addListener(listener);
  }

  /// Disposes the scroll controller if it should be disposed.
  void dispose() {
    if (shouldDisposeController) {
      _scrollController.dispose();
    }
  }

  /// Returns the scroll controller.
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

/// Controller for managing a searchable list with lazy loading.
class SearchableListController<T extends AbstractListItem> extends AbstractListController<T> {
  final SearchableDataFetcher<T> fetch;
  late LazyList<T> items;

  bool _gotUpdated = false;

  /// Creates a [SearchableListController] with the specified data fetcher.
  SearchableListController(this.fetch, {super.scrollController, super.onError}) {
    items = LazyList<T>(fetch: fetch);
  }

  /// Sets the query for the data fetcher and updates the list.
  set query(String? query) {
    _gotUpdated = true;
    items = LazyList<T>(
      fetch: ({limit = 10, offset = 0}) {
        return fetch(limit: limit, offset: offset, query: query);
      },
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
  bool get shouldReload => (scrollReachedLimit || hasBeenUpdated) && canReload;

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

  /// Returns whether the list has been updated.
  bool get hasBeenUpdated {
    final currentVal = _gotUpdated;
    _gotUpdated = false;
    return currentVal;
  }
}

/// Controller for managing a list with lazy loading.
class ListController<T extends AbstractListItem> extends AbstractListController<T> {
  final DataFetcher<T> fetch;
  late final LazyList<T> items;
  late List<T>? initial;

  /// Creates a [ListController] with the specified data fetcher and optional initial list.
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
  bool get shouldReload => (scrollReachedLimit) && canReload || firstTimeLoadingAndNotFailed;

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