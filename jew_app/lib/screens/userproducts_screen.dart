import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';
import '/screens/Drawer_screen.dart';
import '/screens/Edit_productsScreen.dart';
import '/widgets/user_productItem.dart';

class UserProducts extends StatelessWidget {
  static const routename = '/userproducts';

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products_provider>(context, listen: false)
        .fetchandsetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products_provider>(context);
    print("rebuilding");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Your Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routename);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products_provider>(
                      builder: (ctx, productData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserItem(
                                productData.items[i].id,
                                productData.items[i].title,
                                productData.items[i].imageurl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
