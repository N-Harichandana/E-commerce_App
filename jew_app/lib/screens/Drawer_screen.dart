import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '/screens/orders_screen.dart';
// import 'package:shop_app/screens/userproducts_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Container(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //   colors: [
        //     Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
        //     Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   stops: [0, 1],
        // )),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Color.fromRGBO(74, 17, 96, 1).withOpacity(0.5),
              title: Text("Hey Buddy!!"),
              automaticallyImplyLeading: false,
            ),
            Divider(
              color: Colors.white,
            ),
            ListTile(
              // focusColor: Colors.black,
              leading: Icon(
                Icons.shop,
                color: Colors.white,
              ),
              title: Text(
                "Shop",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/");
              },
            ),
            Divider(
              color: Colors.white,
            ),
            ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.white,
              ),
              title: Text(
                "Orders",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, OrderScreen.routename);
              },
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.edit),
            //   title: Text("Manage Products"),
            //   onTap: () {
            //     Navigator.pushReplacementNamed(context, UserProducts.routename);
            //   },
            // ),
            Divider(
              color: Colors.white,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: Text(
                "Log Out",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/");
                // Navigator.pushReplacementNamed(context, UserProducts.routename);
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            Divider(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
