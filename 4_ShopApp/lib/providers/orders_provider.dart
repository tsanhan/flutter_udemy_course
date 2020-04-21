import 'dart:convert';

import 'package:flutter/foundation.dart';

import './cart_provider.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.dateTime, @required this.id, @required this.products});
}

class OrdersProvider with ChangeNotifier {
  final String authToken;
  final String userId;

  OrdersProvider(this.authToken, this._orders, this.userId);

  static const String url =
      'https://shop-app-flutter-course-c2ac4.firebaseio.com/orders';
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final fetchUrl = '$url/$userId.json?auth=$authToken';
    try {
      final response = await http.get(fetchUrl);
      if (response.body == null) return;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null || extractedData["error"] != null) return;
      _orders = _createOrders(extractedData).toList();

      notifyListeners();
    } catch (e) {
      throw e;
    } finally {}
  }

  CartItem _createCartItem(Map<String, dynamic> p) {
    return CartItem(
        id: p['id'],
        quantity: p['quantity'],
        product: Product(
            description: p['product']['description'],
            id: p['product']['id'],
            imageUrl: p['product']['imageUrl'],
            price: p['product']['price'],
            title: p['product']['title']));
  }

  Iterable<OrderItem> _createOrders(dynamic data) sync* {
    for (var key in data.keys) {
      final id = data[key] as Map<String, dynamic>;
      yield OrderItem(
          dateTime: DateTime.parse(id['dateTime']),
          id: key,
          products: (id['products'] as List<dynamic>)
              .map((p) => _createCartItem(p))
              .toList());
    }
  }

  Future<void> addOrder(List<CartItem> products) async {
    final addUrl = '$url/$userId.json?auth=$authToken';
    final timestemp = DateTime.now();

    final jsonEncode = json.encode({
      "dateTime": timestemp.toIso8601String(),
      "products": products
          .map((p) => {
                "quantity": p.quantity,
                "product": {
                  "description": p.product.description,
                  "isFavorite": p.product.isFavorite,
                  "imageUrl": p.product.imageUrl,
                  "price": p.product.price,
                  "title": p.product.title,
                  "id": p.product.id
                },
                "id": p.id
              })
          .toList()
    });
    try {
      final res = await http.post(addUrl, body: jsonEncode);

      final orderItemToAdd = OrderItem(
          id: json.decode(res.body)['name'],
          dateTime: timestemp,
          products: products);
      _orders.add(orderItemToAdd);
    } catch (e) {}
    notifyListeners();
  }
}
