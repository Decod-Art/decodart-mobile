import 'package:decodart/data/model/abstract_item.dart' show AbstractItemBase, AbstractListItem;
import 'package:mutex/mutex.dart' show Mutex;

typedef OnPressList<T extends AbstractListItem> = void Function(T);
typedef OnError = void Function(Object, StackTrace);

typedef DataFetcher<T> = Future<List<T>> Function({int limit, int offset});
typedef SearchableDataFetcher<T> = Future<List<T>> Function({int limit, int offset, String? query});

/// A lazy-loaded list that fetches data in chunks as needed.
///
/// This class extends [Iterable] and provides methods to fetch data in chunks
/// from a data source. It uses a [Mutex] to ensure that only one fetch operation
/// is performed at a time.
///
/// [T] is the type of items in the list, which must extend [AbstractItemBase].
class LazyList<T extends AbstractItemBase> extends Iterable<T> {
  final List<T> _list = [];
  final DataFetcher<T> fetch;
  final int limit;
  bool hasMore = true;

  final m = Mutex();

  /// Creates a [LazyList] with the specified data fetcher and limit.
  ///
  /// [fetch] is a function that fetches data from a data source.
  /// [limit] specifies the maximum number of items to fetch in each request (default is 10).
  /// [initial] is an optional initial list of items to populate the list.
  LazyList({
    required this.fetch,
    this.limit = 10,
    List<T>? initial,
  }) {
    if (initial != null) {
      _list.addAll(initial);
    }
  }

  /// Fetches more items from the data source and adds them to the list.
  ///
  /// This method acquires a mutex to ensure that only one fetch operation is performed
  /// at a time. It updates the [hasMore] flag based on the number of items fetched.
  Future<void> fetchMore() async {
    await m.acquire();
    try {
      if (hasMore) {
        final List<T> results = await fetch(limit: limit, offset: _list.length);
        hasMore = results.length == limit;
        _list.addAll(results);
      }
    } finally {
      m.release();
    }
  }

  /// Returns the list of items.
  List<T> get list => _list;

  @override
  int get length => _list.length;

  @override
  T get first => _list.first;

  @override
  T get last => _list.last;

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  /// Returns the item at the specified [index].
  T operator [](int index) => _list[index];

  @override
  Iterator<T> get iterator => _list.iterator;
}