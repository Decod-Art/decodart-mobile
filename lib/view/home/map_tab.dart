import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/view/details/artwork/artwork.dart' show ArtworkDetailsWidget;
import 'package:decodart/view/details/museum.dart' show MuseumWidget;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;

class MapTab extends StatefulWidget {
  final Future<List<GeolocatedListItem>> markers;
  const MapTab({super.key, required this.markers});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  List<Marker> markers = [];
  List<GeolocatedListItem>? items;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    items = await widget.markers;
    for(var item in items!) {
      markers.add(Marker(
        point: item.coordinates,
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            if (item.isMuseum) {
              Navigator.of(context, rootNavigator: false).push(
                CupertinoPageRoute(builder: (context) => MuseumWidget(
                  title: item.title,
                  museumId: item.uid
                  )
                ),
              );
            } else {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height, // Couvre toute la hauteur de l'écran
                    color: CupertinoColors.black, // Fond blanc par défaut
                    child: ArtworkDetailsWidget(artworkId: item.uid),
                  );
                },
              );
            }
          },
          child: Column(
            children: [
              CircleAvatar(
                //backgroundImage: NetworkImage(item.image.path), // Utilisez item.image pour l'URL de l'image
                radius: 30, // Ajustez la taille du cercle selon vos besoins
                backgroundColor: Colors.white, // Bordure blanche
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
                  fontSize: 10, // Ajustez la taille du texte selon vos besoins
                  color: Color.fromARGB(255, 99, 98, 98), // Couleur du texte
                ),
                overflow: TextOverflow.ellipsis, // Ajoutez cette ligne pour gérer le débordement
                maxLines: 1,
              ),
            ],
          ),
        )
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(43.611299, 3.875854),
          initialZoom: 15.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}r.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
            //tileBuilder: darkModeTileBuilder,
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => {}, // Remplacer par la fonctionnalité souhaitée, par exemple launchUrl
              ),
            ],
          ),
          MarkerLayer(
            markers: markers,
          ),
        ]
      ),
    );
  }
}