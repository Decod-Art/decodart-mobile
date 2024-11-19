import 'package:decodart/model/abstract_item.dart' show AbstractItemBase, AbstractListItem;
import 'package:mutex/mutex.dart' show Mutex;

typedef OnPressList<T extends AbstractListItem> = void Function(T);
typedef OnError = void Function(Object, StackTrace);

typedef DataFetcher<T> = Future<List<T>> Function({int limit, int offset});
typedef SearchableDataFetcher<T> = Future<List<T>> Function({int limit, int offset, String? query});

class LazyList<T extends AbstractItemBase> extends Iterable<T> {
  final List<T> _list = [];
  final DataFetcher<T> fetch;
  final int limit;
  bool hasMore = true;

  final m = Mutex();

  LazyList({
    required this.fetch,
    this.limit=10,
    List<T>? initial
  }) {
    if (initial!=null){
      _list.addAll(initial);
    }
  }

  Future<void> fetchMore () async {
    await m.acquire();
    try {
      if (hasMore){
        final List<T> results = await fetch(limit: limit, offset: _list.length);
        hasMore = results.length == limit;
        _list.addAll(results);
      }
    } finally {
      m.release();
    }
  }

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

  T operator [](int index) => _list[index];
  
  @override
  Iterator<T> get iterator => _list.iterator;
}
