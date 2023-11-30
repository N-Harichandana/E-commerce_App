import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '/providers/cart.dart';
import '/providers/orders.dart';
import '/providers/products_provider.dart';
import '/screens/AuthScreen.dart';
import '/screens/Edit_productsScreen.dart';
import '/screens/cart_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/products_overview_screens.dart';
import '/screens/splashscreen.dart';
import '/screens/userproducts_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products_provider>(
            // Replace this with your intended initialization logic
            update: (ctx, auth, previousProducts) {
              final token = auth.token ??
                  ''; // Provide a default value if auth.token is null
              final items = previousProducts?.items ??
                  []; // Provide a default value if previousProducts or items is null

              return Products_provider(token, auth.userId, items);
            },
            create: (context) {
              return Products_provider("", " ", []);
            },
          ),
          ChangeNotifierProvider(create: (context) => Cart()),
          // ChangeNotifierProvider(create: (context) => Order()),
          ChangeNotifierProxyProvider<Auth, Order>(
            // Replace this with your intended initialization logic
            update: (ctx, auth, previousProducts) {
              final token = auth.token ??
                  ''; // Provide a default value if auth.token is null
              final items = previousProducts?.orders ??
                  []; // Provide a default value if previousProducts or items is null

              return Order(token, auth.userId, items);
            },
            create: (context) {
              return Order("", " ", []);
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
              primaryColor: Colors.purple,
            ),
            debugShowCheckedModeBanner: false,
            home: auth.isAuth
                ? ProductsoverviewScreen()
                : FutureBuilder(
                    future: auth.tryautoLogin(),
                    builder: (ctx, authResultSanpshot) =>
                        authResultSanpshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailScreen.routname: (context) => ProductDetailScreen(),
              CartScreen.routename: (context) => CartScreen(),
              OrderScreen.routename: (context) => OrderScreen(),
              UserProducts.routename: (context) => UserProducts(),
              EditProductScreen.routename: (context) => EditProductScreen(),
            },
          ),
        ));
  }
}
