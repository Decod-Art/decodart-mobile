import 'dart:math' show Point;

import 'package:decodart/api/geolocated.dart' show fetchAllOnMap;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/view/map/summary.dart' show GeolocatedSummaryWidget;
import 'package:decodart/widgets/navigation/small_modal.dart' show showSmallModal;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart' show CircleAvatar;
import 'package:flutter_map_animations/flutter_map_animations.dart' show AnimatedMapController;
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;

class MapView extends StatefulWidget{
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}


class MarkerWithUID extends Marker {
  final int uid;
  const MarkerWithUID({
    required super.point,
    required super.child,
    required this.uid,
    super.width,
    super.height
  });
  
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  List<MarkerWithUID> markers = [];
  late final mapController = AnimatedMapController(vsync: this);

  // position of the modal window
  final GlobalKey modalKey = GlobalKey();
  bool showSearchButton = true;

  @override
  void initState() {
    super.initState();
    mapController.mapController.mapEventStream.listen(_onMapMoved);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMarkers();
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
  void _onMapMoved(MapEvent event) {
    if (event is MapEventMoveEnd||event is MapEventDoubleTapZoomEnd) {
      _loadMarkers();
    }
  }

  void _moveMap(GeolocatedListItem item) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? modalBox = modalKey.currentContext?.findRenderObject() as RenderBox?;
      if (modalBox != null) {
        final screenHeight = MediaQuery.of(context).size.height;
        final modalHeight = modalBox.size.height;
        final offset = (screenHeight - modalHeight-160)/2;
        
        final camera = mapController.mapController.camera;

        final itemPoint = camera.latLngToScreenPoint(item.coordinates);
        final centerPointOffset = Point(0.0,offset-camera.latLngToScreenPoint(camera.center).y);
        final newCenter = camera.layerPointToLatLng(itemPoint + camera.pixelBounds.topLeft - centerPointOffset);
        mapController.animateTo(
          dest: newCenter,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }
 
  Future<void> _loadMarkers() async {
    const buffer = 0.5; 
    // The function is a bit complex
    // because it must not reconstruct markers that were already available.
    // To avoid blinking effects
    final visibleRegion = mapController.mapController.camera.visibleBounds;
    final newItems = await fetchAllOnMap(
      minLatitude: visibleRegion.south - buffer * (visibleRegion.north-visibleRegion.south),
      maxLatitude: visibleRegion.north + buffer * (visibleRegion.north-visibleRegion.south),
      minLongitude: visibleRegion.west - buffer * (visibleRegion.east-visibleRegion.west),
      maxLongitude: visibleRegion.east + buffer * (visibleRegion.east-visibleRegion.west)
    );
    final newUids = newItems.map((item) => item.uid).toSet();

    List<MarkerWithUID> updatedMarkers = [];
    for (int i = 0; i < markers.length; i++) {
      if (newUids.contains(markers[i].uid)) {
        updatedMarkers.add(markers[i]);
      }
    }
    markers = updatedMarkers;

    for (var item in newItems) {
      if (!markers.any((existingItem) => existingItem.uid == item.uid)) {
        markers.add(MarkerWithUID(
          uid: item.uid!,
          point: item.coordinates,
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              showSmallModal(
                context,
                (context) => GeolocatedSummaryWidget(item: item, key: modalKey)
                );
              _moveMap(item);
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
          )
        ));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'Carte',
      smallTitle: true,
      child: SafeArea(
        child: FlutterMap(
          mapController: mapController.mapController,
          options: const MapOptions(
            initialCenter: LatLng(43.611299, 3.875854),
            initialZoom: 15.2,
            interactionOptions: InteractionOptions(
              enableMultiFingerGestureRace: true,
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
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
                  onTap: () => {},
                ),
              ],
            ),
            MarkerLayer(
              markers: markers,
            ),
          ]
        ),
      )
    );
  }
}