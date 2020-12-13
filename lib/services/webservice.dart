import 'dart:convert';

import 'package:place_finder/models/place.dart';
import 'package:place_finder/utils/urlHelper.dart';
import 'package:http/http.dart' as http;

class WebService {
  Future<List<Place>> fetchPlacesByKewordAndPosition(
      String keyword, double latitude, double longitude) async {
    final url =
        UrlHelper.urlForPlaceKeywordAndLocation(keyword, latitude, longitude);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final Iterable results = jsonResponse["results"];
      return results.map((place) => Place.fromJSON(place));
    } else {
      throw Exception("Unable to perform request");
    }
  }
}
