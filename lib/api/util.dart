import 'package:decodart/model/abstract_item.dart' show AbstractItemBase;


const String hostName = 'http://192.168.1.23:8000';
const String cdn = 'http://192.168.1.23:8000/cdn_images';

String? checkUrlForCdn(String? url) {
  if (url == null) {
    return url;
  }
  if (url.startsWith('http://')||url.startsWith('https://')) {
    return url;
  }
  return "$cdn/$url";
}

typedef DataFetcher<T> = Future<List<T>> Function({int limit, int offset});
typedef SearchableDataFetcher<T> = Future<List<T>> Function({int limit, int offset, String? query});

class LazyList<T extends AbstractItemBase> extends Iterable<T> {
  final List<T> _list = [];
  final DataFetcher<T> fetch;
  final int limit;
  int _offset=0;
  bool hasMore = true;

  LazyList({
    required this.fetch,
    this.limit=10,
    List<T>? initial
  }) {
    if (initial!=null){
      _list.addAll(initial);
      _offset += initial.length;
    }
  }

  Future<void> fetchMore () async {
    if (hasMore){
      final List<T> results = await fetch(limit: limit, offset: _offset);
      _offset += results.length;
      hasMore = results.length == limit;
      _list.addAll(results);
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

class Fetcher<T extends AbstractItemBase> {
  final Future<List<T>> Function({int limit, int offset}) fetch;

  Fetcher({required this.fetch});

  Future<List<T>> call({int limit = 10, int offset = 0}) {
    return fetch(limit: limit, offset: offset);
  }
}