
import 'package:decodart/controller/global/hive.dart' show HiveService;
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
  static const String recentScanBoxName = 'recentScan';
  final List<ArtworkListItem> recent = [];

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  void dispose() {
    HiveService().closeBox(recentScanBoxName);
    super.dispose();
  }

  void _fetchHistory() {
    // the method is called each time the Hive box is updated with new elements
    Box<List>? recentScanBox = HiveService().getBox(recentScanBoxName);
    List<hive.ArtworkListItem>? recentList = recentScanBox
      ?.get('recent', defaultValue: [])
      ?.cast<hive.ArtworkListItem>();
    if(recentList != null){
      recent.clear();
      recent.addAll(recentList.map((item) => ArtworkListItem.fromHive(item)).toList());
    }
  }

  Future<void> _openBox() async {                    
    await HiveService().openBox<List>(recentScanBoxName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return HiveService().getBox(recentScanBoxName)==null
      ? const Center(
          child: CupertinoActivityIndicator(),
        )
      : ValueListenableBuilder(
        valueListenable: HiveService().getBox(recentScanBoxName)!.listenable(),
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
    );
  }
}