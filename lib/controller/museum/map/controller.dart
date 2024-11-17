import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/room.dart' show fetchRooms;
import 'package:decodart/controller/widgets/list_controller/_util.dart' show LazyList, SearchableDataFetcher;
import 'package:decodart/controller/widgets/list_controller/controller.dart' show AbstractListController;
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/museum.dart' show MuseumForeignKey, MuseumListItem;
import 'package:decodart/model/room.dart' show RoomListItem;

class MuseumMapController extends AbstractListController<RoomListItem>{
  late LazyList<RoomListItem> items = LazyList<RoomListItem>(fetch: _fetchRooms, limit: 5);
  List<SearchableDataFetcher<ArtworkListItem>> fetchers = [];
  List<List<ArtworkListItem>> initialValues = [];
  final MuseumListItem museum;

  MuseumMapController(this.museum, {super.scrollController, super.onError});

  Future<List<RoomListItem>> _fetchRooms({int limit=5, int offset=0}) async {
    return fetchRooms(
      museum: MuseumForeignKey(
        name: museum.name,
        uid: museum.uid),
      limit: limit,
      offset: offset
    );
  }

  @override
  RoomListItem operator [](int index) => items[index];

  @override
  RoomListItem get first => items.first;

  @override
  bool get hasMore => items.hasMore;

  @override
  bool get isEmpty => items.isEmpty;

  @override
  bool get isNotEmpty => items.isNotEmpty;

  @override
  Iterator<RoomListItem> get iterator => items.iterator;

  @override
  RoomListItem get last => items.last;

  @override
  int get length => items.length;

  @override
  List<RoomListItem> get list => items.list;

  @override
  Future<void> fetchMoreAPI() async {
    await items.fetchMore();
  }

  @override
  void afterCompleting() {
    for (int i = fetchers.length ; i < items.length ; i++) {
      fetchers.add(
        ({int limit=10, int offset=0, String? query}) {
          return fetchAllArtworks(limit: limit, offset: offset, museumId: museum.uid, room: items[i].name, query: query);
        }
      );
      // Initial values to avoid calling multiple times the API.. while we have a set of artworks already loaded.
      initialValues.add(
        items[i].artworks
      );
    }
  }

}