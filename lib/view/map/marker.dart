import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/view/map/summary.dart' show GeolocatedSummaryWidget;
import 'package:decodart/widgets/navigation/small_modal.dart' show showSmallModal;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircleAvatar;


class DecodMarkerUI extends StatelessWidget {
  final VoidCallback onPress;
  final GeolocatedListItem item;
  // to obtain info about the modal window
  final GlobalKey modalKey;

  int get uid => item.uid!;

  const DecodMarkerUI({
    super.key,
    required this.onPress,
    required this.item,
    required this.modalKey

    });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        showSmallModal(
          context,
          (context) => GeolocatedSummaryWidget(item: item, key: modalKey)
          );
        onPress();
      },
      child: Column(
        children: [
          CircleAvatar(
            //backgroundImage: NetworkImage(item.image.path), // Utilisez item.image pour l'URL de l'image
            radius: 30, // Ajustez la taille du cercle selon vos besoins
            backgroundColor: CupertinoColors.white, // Bordure blanche
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: item.image.path,
                fit: BoxFit.cover,
                width: 56,
                height: 56)
            ),
          ),
          const SizedBox(height: 4), // Espace entre l'image et le texte
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 10,
              color: Color.fromARGB(255, 99, 98, 98), // Couleur du texte
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

}