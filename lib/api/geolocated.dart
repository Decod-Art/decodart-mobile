import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:decodart/api/util.dart' show hostName;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;

Future<List<GeolocatedListItem>>  fetchAllOnMap({
  required double minLatitude,
  required double maxLatitude,
  required double minLongitude,
  required double maxLongitude}) async {
    try {
    final response = await http.get(Uri.parse(
      '$hostName/geolocated?minLat=$minLatitude&maxLat=$maxLatitude&minLon=$minLongitude&maxLon=$maxLongitude'));
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      List<GeolocatedListItem> listItems = results['data'].map((item) => GeolocatedListItem.fromJson(item))
                                                          .toList()
                                                          .cast<GeolocatedListItem>();
      return listItems;
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
  return [];
}

Future<List<GeolocatedListItem>>  fetchAroundMe({
  int limit=10,
  int offset=0,
  String? query,
  double latitude=43.612286,
  double longitude=3.880830
}) async {
  try {
    final url = '$hostName/geolocated/aroundme?limit=$limit&offset=$offset&latitude=$latitude&longitude=$longitude${query!=null?"&query=$query":""}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      List<GeolocatedListItem> listItems = results['data'].map((item) => GeolocatedListItem.fromJson(item))
                                                          .toList()
                                                          .cast<GeolocatedListItem>();
      return listItems;
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
  return [];
}