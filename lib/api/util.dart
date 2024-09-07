import 'package:decodart/model/abstract_item.dart' show AbstractListItem;

const String hostName = 'http://192.168.1.17:8000';
const String cdn = 'http://192.168.1.17:8000/cdn_images';

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

class LazyList<T extends AbstractListItem> extends Iterable<T> {
  final List<T> _list = [];
  final DataFetcher<T> fetch;
  final int limit;
  int _offset=0;
  bool hasMore = true;

  LazyList({
    required this.fetch,
    this.limit=50
  });

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
