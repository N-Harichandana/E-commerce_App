import 'dart:convert';

import 'package:flutter/material.dart';
import '/providers/cart.dart';
// import 'package:shop_app/widgets/cart_item.dart';
import 'package:http/http.dart' as http;

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItems(
      {required this.id,
      required this.amount,
      required this.datetime,
      required this.products});
}

class Order with ChangeNotifier {
  List<OrderItems> _orders = [];
  final String authToken;
  final String userid;
  Order(this.authToken, this.userid, this._orders);
  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchandstoreOrders() async {
    final url =
        "https://my-shop-f507a-default-rtdb.firebaseio.com/orders/$userid.json?auth=$authToken";
    final response = await http.get(Uri.parse(url));
    final List<OrderItems> loadedOrders = [];
    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(extractedData);
      extractedData.forEach((orderid, Orderdata) {
        loadedOrders.add(OrderItems(
            id: orderid,
            amount: Orderdata['amount'],
            datetime: DateTime.parse(Orderdata['id']),
            products: (Orderdata['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
                .toList()));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addorder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://my-shop-f507a-default-rtdb.firebaseio.com/orders/$userid.json?auth=$authToken";
    final timestamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'id': timestamp.toIso8601String(),
          'amount': total,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItems(
            id: json.decode(response.body)['name'],
            amount: total,
            datetime: timestamp,
            products: cartProducts));

    notifyListeners();
  }
}
