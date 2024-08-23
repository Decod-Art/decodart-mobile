import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:decodart/api/util.dart' show hostName;
import 'package:decodart/model/geolocated.dart' show GeolocatedListItem;

Future<List<GeolocatedListItem>>  fetchAllOnMap() async {
    try {
    final response = await http.get(Uri.parse('$hostName/geolocated/'));
    if (response.statusCode == 200) {
      List<GeolocatedListItem> listItems = jsonDecode(response.body).map((item) => GeolocatedListItem.fromJson(item))
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

Future<List<GeolocatedListItem>>  fetchAroundMe() async {
    try {
    final response = await http.get(Uri.parse('$hostName/geolocated/aroundme'));
    if (response.statusCode == 200) {
      List<GeolocatedListItem> listItems = jsonDecode(response.body).map((item) => GeolocatedListItem.fromJson(item))
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