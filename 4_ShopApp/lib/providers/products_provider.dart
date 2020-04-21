import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

import '../providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
    static const  String url = 'https://shop-app-flutter-course-c2ac4.firebaseio.com/products';
    static const  String favProdsUrl = 'https://shop-app-flutter-course-c2ac4.firebaseio.com/userFavorites';
  
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Iterable<Product> _createProducts(Map<String, dynamic> data, Map<String, dynamic> favData) sync* {
    for (var key in data.keys) {
      final id = data[key] as Map<String, dynamic>;
      yield Product(
          description: id['description'],
          id: key,
          imageUrl: id['imageUrl'],
          price: id['price'],
          title: id['title'],
          isFavorite: favData == null ? false : favData[key] ?? false);
    }
  }

  final String authToken;
  final String userId;
  ProductsProvider(this.authToken, this._items, this.userId);

  // I want to see all products on main screen by only user's products on user's products page
  Future<void> fetchAndSetProducts([bool filterByUder = false]) async {
    final filterString = filterByUder ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final fetchUrl = '$url.json?auth=$authToken$filterString';
    try {
      final response = await http.get(fetchUrl);
      if(response.body == null) return;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      
      _items = [];
      if(extractedData["error"] != null) return;
      
      final fetchFavUrl = '$favProdsUrl/$userId.json?auth=$authToken';
      final favResp = await http.get(fetchFavUrl);
      final favData = json.decode(favResp.body) as Map<String,dynamic>;

      _items.addAll(_createProducts(extractedData, favData));
      
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final addUrl = '$url.json?auth=$authToken';

    try {
      final res = await http.post(addUrl,
          body: json.encode({
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "title": product.title,
            'creatorId': userId
          }));

      final newProduct = Product(
          description: product.description,
          id: json.decode(res.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);

      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> editProduct(Product product) async {
    final editUrl = '$url/${product.id}.json?auth=$authToken';
    await http.patch(editUrl,
        body: json.encode({
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "title": product.title
        }));

    final loc = _items.indexWhere((p) => p.id == product.id);
    _items[loc] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
      final deleteUrl = '$url/${product.id}.json?auth=$authToken';
     final prodIndex = _items.indexWhere((p) => p.id == product.id);
    var exsistProd = _items[prodIndex];
      _items.removeAt(prodIndex);
      notifyListeners();

    final res = await http.delete(deleteUrl);
    
    if (res.statusCode >= 400) {
      _items.insert(prodIndex, exsistProd);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    exsistProd = null;
  
    
  }

  List<Product> get favoriteItems {
    return [..._items.where((i) => i.isFavorite).toList()];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
