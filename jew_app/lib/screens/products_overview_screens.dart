import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart.dart';
import '/providers/products_provider.dart';
import '/screens/Drawer_screen.dart';
import '/screens/cart_screen.dart';
import '/widgets/badge.dart';

import '/widgets/products_grid.dart';

enum filterOptions { Favourites, All }

class ProductsoverviewScreen extends StatefulWidget {
  @override
  State<ProductsoverviewScreen> createState() => _ProductsoverviewScreenState();
}

class _ProductsoverviewScreenState extends State<ProductsoverviewScreen> {
  var _showonlyfav = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products_provider>(context)
          .fetchandsetProducts()
          .then((_) => _isLoading = false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(163, 76, 198, 1).withOpacity(0.5),
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
              onSelected: (filterOptions selectedvalue) {
                setState(() {
                  if (selectedvalue == filterOptions.Favourites) {
                    _showonlyfav = true;
                  } else {
                    _showonlyfav = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Only favourites"),
                      value: filterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text("All"),
                      value: filterOptions.All,
                    )
                  ]),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badgee(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routename);
                        },
                        icon: Icon(Icons.shopping_cart)),
                    value: cart.itemCount.toString(),
                    color: Colors.redAccent,
                  ))
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productsGrid(_showonlyfav),
    );
  }
}
