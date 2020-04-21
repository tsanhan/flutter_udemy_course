import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyAG8PhWkYgQa9jve_HUHLvb9ds11oYrw14';

class LocationHelper {
  static String generateLocPreviewImg({double lat, double long}) {
    //  https://maps.googleapis.com/maps/api/staticmap?center=31.7275489,35.1873003&size=600x300&markers=color:green%7Clabel:G%7C31.7275489,35.1873003&key=AIzaSyAG8PhWkYgQa9jve_HUHLvb9ds11oYrw14

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&markers=color:green%7Clabel:A%7C$lat,$long&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$GOOGLE_API_KEY";
    final resopnse = await http.get(url);
    final rtn = json.decode(resopnse.body)['results'][0]['formatted_address'];
    return rtn;
  }
}