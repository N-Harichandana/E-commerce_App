import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageurl;
  final double price;
  bool isfavourite;

  Products(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageurl,
      this.isfavourite = false});

  void _setFav(bool newValue) {
    isfavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteState(String token, String userid) async {
    final oldstatus = isfavourite;
    isfavourite = !isfavourite;
    notifyListeners();
    final url =
        "https://my-shop-f507a-default-rtdb.firebaseio.com/userfav/$userid/$id.json?auth=$token";
    try {
      final response =
          await http.put(Uri.parse(url), body: json.encode(isfavourite));
      if (response.statusCode >= 400) {
        _setFav(oldstatus);
      }
    } catch (error) {
      _setFav(oldstatus);
    }
  }
}
