import 'package:decodart/model/artwork.dart' show ArtworkListItem;
import 'package:decodart/model/hive/artwork.dart' as hive show ArtworkListItem;
import 'package:decodart/view/artwork/future_artwork.dart' show FutureArtworkView;
import 'package:decodart/controller_and_mixins/decod/menu_controller.dart' show MenuController;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A widget that displays the history of decoded artworks.
/// 
/// The `DecodedHistory` is a stateful widget that retrieves and displays a list of decoded artworks from a Hive database.
/// It shows the artworks in a list with thumbnails and allows users to tap on an item to view detailed information in a modal.
/// 
/// Attributes:
/// 
/// - `key` (optional): A [Key] to uniquely identify the widget.
class DecodedHistory extends StatefulWidget{
  const DecodedHistory({super.key});

  @override
  State<DecodedHistory> createState() => DecodedHistoryState();
}

class DecodedHistoryState extends State<DecodedHistory> {
  final MenuController controller = MenuController();
  final List<ArtworkListItem> decoded = [];

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _fetchHistory() {
    List<hive.ArtworkListItem> history = controller.decodedArtworkHistory;
    if (history.length != decoded.length){
      decoded.clear();
      decoded.addAll(history.map((item) => ArtworkListItem.fromHive(item)).toList());
    }
  }

  Future<void> _openBox() async {
    await controller.openBoxes();     
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: controller.isNotOpened
        ? const Center(child: CupertinoActivityIndicator())
        : ValueListenableBuilder(
          valueListenable: controller.decodedArtworkHistoryBox.listenable(),
          builder: (context, __, _) {
            // if the listener detected a change in the box,
            // call _fetchHistory to reload the content of the history list
            _fetchHistory();
            return decoded.isEmpty
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 15),
                      child: Text(
                        'Œuvres décodées',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500))
                      ),
                    ListWithThumbnail(items: decoded, onPress: (item) => showWidgetInModal(context, (context) => FutureArtworkView(artwork: item)))
                  ],
                );
          }
        )
    );
  }
}