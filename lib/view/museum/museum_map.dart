import 'package:decodart/api/artwork.dart' show fetchAllArtworks;
import 'package:decodart/api/room.dart' show fetchRooms;
import 'package:decodart/model/museum.dart' show Museum, MuseumForeignKey;
import 'package:decodart/model/room.dart' show RoomListItem;
import 'package:decodart/view/museum/map_viewer.dart' show FullScreenPDFViewer;
import 'package:decodart/widgets/buttons/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/list/content_block.dart' show ContentBlock;
import 'package:flutter/cupertino.dart';

class MuseumMap extends StatefulWidget {
  final bool isModal;
  final Museum museum;
  final String? museumMapPath;

  const MuseumMap({super.key, this.museumMapPath, required this.museum, required this.isModal});
  
  @override
  State<MuseumMap> createState() => _MuseumMapState();
}

class _MuseumMapState extends State<MuseumMap> {
  List<RoomListItem> rooms = [];

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }
  void _fetchRooms() async {
    rooms = await fetchRooms(museum: MuseumForeignKey(name: widget.museum.name, uid: widget.museum.uid));
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        ChevronButtonWidget(
          // https://museefabre-old.montpellier3m.fr/content/download/12182/92171/version/2/file/Musee_Fabre-Plans.pdf
          text: "Voir le plan du musée",
          subtitle: 'Document pdf',
          icon: const Icon(
            CupertinoIcons.doc,
            color: CupertinoColors.activeBlue,
          ),
          onPressed: (){
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (context) => FullScreenPDFViewer(
                  pdfUrl: widget.museumMapPath ?? 'https://api-www.louvre.fr/sites/default/files/2022-03/LOUVRE_PlanG-2022-FR_0.pdf',
                ),
              ),
            );
          },
        ),
        for (final room in rooms) ... [
          ContentBlock(
            title: "Salle ${room.name}",
            fetch: ({int limit=10, int offset=0, String? query}) {
              return fetchAllArtworks(limit: limit, offset: offset, museumId: widget.museum.uid, room: room.name, query: query);
            },
            onPressed: (a){},
            isModal: widget.isModal,
          )
        ]
      ],
    );
  } 
}