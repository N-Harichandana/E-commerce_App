import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});

  // String get proid {
  //   return id;
  // }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalamount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void additem(String productid, String title, double price) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (existingCartitem) => CartItem(
              id: existingCartitem.id,
              title: existingCartitem.title,
              quantity: existingCartitem.quantity + 1,
              price: existingCartitem.price));
    } else {
      _items.putIfAbsent(
          productid,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void remove_item(String proid) {
    // print(_items);
    _items.remove(proid);
    // _items
    //     .removeWhere((key, value) => key == 'id' && value.toString() == proid);
    // print(_items);
    notifyListeners();
  }

  void remove_singleItem(String proid) {
    if (!_items.containsKey(proid)) {
      return;
    }
    if (_items[proid]!.quantity > 1) {
      _items.update(
          proid,
          (existingcartitem) => CartItem(
              id: existingcartitem.id,
              title: existingcartitem.title,
              quantity: existingcartitem.quantity - 1,
              price: existingcartitem.price));
    } else {
      _items.remove(proid);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
