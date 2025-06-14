import 'dart:math' show Point;

import 'package:decodart/data/api/geolocated.dart' show fetchAllOnMap;
import 'package:decodart/data/model/geolocated.dart' show GeolocatedListItem;
import 'package:decodart/util/logger.dart' show logger;
import 'package:decodart/ui/map/widgets/marker.dart' show DecodMarkerUI;
import 'package:decodart/ui/core/scaffold/decod_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart' show AnimatedMapController;
import 'package:latlong2/latlong.dart' show LatLng;

/// A widget that displays a map view in the Decod app.
/// 
/// The `MapView` is a stateful widget that shows a map with markers representing geolocated items.
/// It fetches data from an API and displays the items as markers on the map. The user can interact with the map and select markers to view more details.
/// 
/// Attributes:
/// 
/// - `key` (optional): A [Key] to uniquely identify the widget.
class MapView extends StatefulWidget{
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

/// A custom marker class that includes a unique identifier (UID).
class MarkerWithUID extends Marker {
  final GeolocatedListItem item;
  const MarkerWithUID({
    required super.point,
    required super.child,
    required this.item,
    super.width,
    super.height
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final MarkerWithUID otherItem = other as MarkerWithUID;
    return otherItem.item == item;
  }

  @override
  int get hashCode => item.hashCode;
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  List<MarkerWithUID> markers = [];
  late final mapController = AnimatedMapController(vsync: this);

  // position of the modal window
  final GlobalKey modalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    mapController.mapController.mapEventStream.listen(_onMapMoved);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMarkers());
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
  void _onMapMoved(MapEvent event) {
    if (event is MapEventMoveEnd||event is MapEventDoubleTapZoomEnd) _loadMarkers();
  }

  /// This function aims at moving the map to center it on the
  /// selected marker
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
    try {
      const buffer = 0.5;
      // The function is a bit complex
      // because it must not reconstruct markers that were already available.
      // To avoid blinking effects
      final visibleRegion = mapController.mapController.camera.visibleBounds;

      final List<GeolocatedListItem> newItems = await fetchAllOnMap(
        minLatitude: visibleRegion.south - buffer * (visibleRegion.north-visibleRegion.south),
        maxLatitude: visibleRegion.north + buffer * (visibleRegion.north-visibleRegion.south),
        minLongitude: visibleRegion.west - buffer * (visibleRegion.east-visibleRegion.west),
        maxLongitude: visibleRegion.east + buffer * (visibleRegion.east-visibleRegion.west)
      );
      
      // first we add the marker in newList that are already 
      // displayed... We retrieve them from the previous "markers" list
      List<MarkerWithUID> newMarkerList = [];
      for (int i = 0; i < markers.length; i++) {
        if (newItems.contains(markers[i].item)) {
          newMarkerList.add(markers[i]);
        }
      }
      markers = newMarkerList;

      // Second we add all markers that are not already available in
      // newMarkerList (i.e. the new "markers" list)
      for (var item in newItems) {
        if (!markers.any((existingItem) => existingItem.item == item)) {
          markers.add(MarkerWithUID(
            item: item,
            point: item.coordinates,
            width: 80,
            height: 80,
            child: DecodMarkerUI(
              onPress: () => _moveMap(item),
              item: item,
              modalKey: modalKey
            )
          ));
        }
      }
      setState(() {});
    } catch(e) {
      logger.e("Failed collecting new markers... Keeping current markers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'Carte',
      smallTitle: true,
      canPop: false,
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
    );
  }
}