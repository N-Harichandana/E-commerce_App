import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/providers/products.dart';
import '/providers/products_provider.dart';

import 'product_item.dart';

class productsGrid extends StatelessWidget {
  final bool showonlyfavs;

  productsGrid(this.showonlyfavs);
  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Products_provider>(context);
    final products = showonlyfavs ? productsdata.favitems : productsdata.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: Product_Item(
            // products[i].id, products[i].title, products[i].imageurl
            ),
      ),
      itemCount: products.length,
      padding: EdgeInsets.all(25.0),
    );
  }
}
