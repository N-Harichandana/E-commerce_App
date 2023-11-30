import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import '/providers/products.dart';
import 'package:http/http.dart' as http;

class Products_provider with ChangeNotifier {
  List<Products> _items = [
    // Products(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: "A red shirt with pretty red Colour",
    //     price: 500,
    //     imageurl:
    //         'https://img0.junaroad.com/uiproducts/17626575/zoom_0-1616768152.jpg'),
    // Products(
    //     id: 'p2',
    //     title: 'Pan',
    //     description: "Best for cooking",
    //     price: 200,
    //     imageurl:
    //         "https://rukminim2.flixcart.com/image/850/1000/xif0q/pot-pan/h/y/o/non-stick-granite-frying-pan-carote-original-imagzfprwdz58rwq.jpeg?q=90"),
    // Products(
    //     id: 'p3',
    //     title: 'Nailpolish',
    //     description: 'shiny colours',
    //     price: 100,
    //     imageurl:
    //         "https://media6.ppl-media.com/tr:h-750,w-750,c-at_max,dpr-2/static/img/product/257440/ny-bae-chrome-crystals-nail-paint-purple-diamond-12-3-ml_1_display_1670592897_f2532a21.jpg"),
    // Products(
    //     id: 'p4',
    //     title: 'Saree',
    //     description: 'Traditional',
    //     price: 1000,
    //     imageurl:
    //         "https://5.imimg.com/data5/SELLER/Default/2022/10/OQ/NU/TD/137563449/katan-silk-sarees.jpeg"),
  ];
  final String authtoken;
  final String userid;
  Products_provider(this.authtoken, this.userid, this._items);

  List<Products> get items {
    return [..._items];
  }

  List<Products> get favitems {
    return _items.where((element) => element.isfavourite).toList();
  }

  Products findbyid(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
    );
  }

  Future<void> fetchandsetProducts([bool filterbyuser = false]) async {
    final filterString =
        filterbyuser ? 'orderBy="creatorId"&equalTo="$userid"' : '';
    var url =
        'https://my-shop-f507a-default-rtdb.firebaseio.com/products.json?auth=$authtoken&$filterString';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url =
          "https://my-shop-f507a-default-rtdb.firebaseio.com/userfav/$userid.json?auth=$authtoken";
      final favourite_response = await http.get(Uri.parse(url));
      final favouriteData = json.decode(favourite_response.body);
      final List<Products> loadedProducts = [];
      // print(extractedData);
      extractedData.forEach((proid, prodata) {
        loadedProducts.add(Products(
            id: proid,
            title: prodata['title'],
            description: prodata['description'],
            price: prodata['price'],
            imageurl: prodata['imageurl'],
            isfavourite:
                favouriteData == null ? false : favouriteData[proid] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Products product) async {
    final url =
        "https://my-shop-f507a-default-rtdb.firebaseio.com/products.json?auth=$authtoken";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageurl': product.imageurl,
          'creatorId': userid
          // 'isFavourite': product.isfavourite
        }),
      );
      final newproduct = Products(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageurl: product.imageurl);
      // _items.add(newproduct);
      _items.insert(0, newproduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Products newproduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    final url =
        "https://my-shop-f507a-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken";
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': newproduct.title,
          'description': newproduct.description,
          'price': newproduct.price,
          'imageurl': newproduct.imageurl
        }));
    _items[prodIndex] = newproduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://my-shop-f507a-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken";
    final existingproductIndex = _items.indexWhere((prod) => prod.id == id);
    Products? existingproduct = _items[existingproductIndex];
    _items.removeAt(existingproductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingproductIndex, existingproduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
    existingproduct = null;
  }
}
