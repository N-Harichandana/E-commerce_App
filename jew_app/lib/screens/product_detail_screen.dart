import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routname = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context)?.settings.arguments as String;
    final loadedproduct =
        Provider.of<Products_provider>(context).findbyid(productid);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 143, 196, 211),
      // backgroundColor: Color.fromARGB(255, 97, 132, 184),

      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 143, 196, 211),
        backgroundColor: Color.fromARGB(255, 101, 145, 157),
        title: Text(loadedproduct.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Center(
                child: Image.network(
                  loadedproduct.imageurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "\$${loadedproduct.price}",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedproduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
