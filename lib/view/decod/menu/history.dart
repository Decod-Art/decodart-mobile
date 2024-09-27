import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/modal_or_fullscreen/modal_or_fullscreen.dart' show showModal;

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DecodedHistory extends StatefulWidget{
  const DecodedHistory({super.key});

  @override
  State<DecodedHistory> createState() => DecodedHistoryState();
}

class DecodedHistoryState extends State<DecodedHistory> {
  Box<List>? artworkHistory;
  final List<ArtworkListItem> decoded = [];

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  void dispose() {
    artworkHistory?.close();
    super.dispose();
  }

  void _fetchHistory() {
    List<hive.ArtworkListItem>? history = artworkHistory
      ?.get('history', defaultValue: [])
      ?.cast<hive.ArtworkListItem>();
    if (history != null && history.length != decoded.length){
      decoded.clear();
      decoded.addAll(history.map((item) => ArtworkListItem.fromHive(item)).toList());
    }
  }

  Future<void> _openBox() async {
    artworkHistory = await Hive.openBox<List>('gameArtworkHistory');      
    setState(() {});
  }

  Future<void> reset() async {
    await artworkHistory?.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: artworkHistory==null
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : ValueListenableBuilder(
          valueListenable: artworkHistory!.listenable(),
          builder: (context, __, _) {
            _fetchHistory();
            return decoded.isEmpty?Container():Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 15),
                  child: Text(
                    'Œuvres décodées',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
                  ),
                ListWithThumbnail(
                  items: decoded, 
                  onPress: (item) async {
                  showModal(
                    context,
                    (context) => FutureArtworkView(artwork: item));
                  }
                )
              ],
            );
          }
        )
    );
  }
}