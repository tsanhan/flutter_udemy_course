import 'dart:convert';

import 'package:http/http.dart' as http;
// need to enable biiling for the project for the key to work
const GOOGLE_API_KEY = 'AIzaSyAG8PhWkYgQa9jve_HUHLvb9ds11oYrw14';

class LocationHelper {
  static String generateLocPreviewImg({double lat, double long}) {

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&markers=color:green%7Clabel:A%7C$lat,$long&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$GOOGLE_API_KEY";
    final resopnse = await http.get(url);
    final rtn = json.decode(resopnse.body)['results'][0]['formatted_address'];
    return rtn;
  }
}