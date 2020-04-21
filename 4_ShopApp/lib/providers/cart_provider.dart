import 'package:flutter/foundation.dart';

import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final String id; 
  CartItem({
    
    @required this.product, 
    @required this.id, 
    @required this.quantity});
}

class CartProvider with ChangeNotifier {
  // Map <product id, cart item containing product>
  Map<String,CartItem> _items = Map<String,CartItem>(); 

  

  Map<String,CartItem> get items{
    return {..._items};
  } 

  int get itemCount{
    return items.values.fold(0, (sum, item) => sum += item.quantity);
  }

  double get totalAmount {
    return items.values.fold(0, (sum, item) => sum += item.product.price * item.quantity);
  }

  void addItem(Product product){
    if(_items.containsKey(product.id)){
      _items.update(product.id, (exsistingCartItem) => CartItem(
        id: exsistingCartItem.id,
        product: exsistingCartItem.product,
        quantity: exsistingCartItem.quantity + 1
      ));
    }else{
      _items.putIfAbsent(product.id,  () => CartItem(
        id: DateTime.now().toString(),
        product: product,
        quantity: 1
      ));
    }
    notifyListeners();

  }

  void removeItem({Product product, bool reMoveAll = true}){

    if(_items.containsKey(product.id) && _items[product.id].quantity > 1 && !reMoveAll){
      _items.update(product.id, (exsistingCartItem) => CartItem(
        id: exsistingCartItem.id,
        product: exsistingCartItem.product,
        quantity: exsistingCartItem.quantity - 1
      ));
    } else {
      _items.remove(product.id);    
    }
    notifyListeners();
  }

  void clear(){
    _items.clear();
    notifyListeners();
  }
}