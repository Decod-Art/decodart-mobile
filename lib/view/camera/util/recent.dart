
import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecentScan extends StatefulWidget{
  const RecentScan({super.key});

  @override
  State<RecentScan> createState() => RecentScanState();
}

class RecentScanState extends State<RecentScan> {
  Box<List>? recentScanBox;
  final List<ArtworkListItem> recent = [];

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  void dispose() {
    recentScanBox?.close();
    super.dispose();
  }

  void _fetchHistory() {
    // the method is called each time the Hive box is updated with new elements
    List<hive.ArtworkListItem>? recentList = recentScanBox
      ?.get('recent', defaultValue: [])
      ?.cast<hive.ArtworkListItem>();
    if (recentList != null && recentList.length != recent.length){
      recent.clear();
      recent.addAll(recentList.map((item) => ArtworkListItem.fromHive(item)).toList());
    }
  }

  Future<void> _openBox() async {
    recentScanBox = await Hive.openBox<List>('recentScan');      
    setState(() {});
  }

  Future<void> reset() async {
    await recentScanBox?.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: recentScanBox==null
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : ValueListenableBuilder(
          valueListenable: recentScanBox!.listenable(),
          builder: (context, __, _) {
            _fetchHistory();
            return recent.isEmpty?Container():Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 15, top: 30),
                  child: Text(
                    'Scans récents',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
                  ),
                ListWithThumbnail(items: recent, onPress: (item) async {
                  showWidgetInModal(context,(context) => FutureArtworkView(artwork: item));
                },)
              ],
            );
          }
        )
    );
  }
}