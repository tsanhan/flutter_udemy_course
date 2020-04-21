import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  static const String url =
      'https://shop-app-flutter-course-c2ac4.firebaseio.com/userFavorites';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  void _setFavValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  
  Product(
      {@required this.description,
      @required this.id,
      @required this.imageUrl,
      @required this.price,
      @required this.title,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    _setFavValue(!isFavorite);

    final prodUrl = '$url/$userId/$id.json?auth=$authToken';
    try {
      //final res = await http.patch(prodUrl, body: json.encode({"isFavorite": isFavorite}));
      final res = await http.put(prodUrl, body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _setFavValue(!isFavorite);
      }
    } catch (e) {
      _setFavValue(!isFavorite);
    }
  }
}
