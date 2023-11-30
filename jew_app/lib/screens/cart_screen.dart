import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart.dart' show Cart;
import '/providers/orders.dart';
import '/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routename = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
    );
    final order = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Color.fromRGBO(70, 26, 87, 1).withOpacity(0.5),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "₹${cart.totalamount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  orderbutton(cart: cart, order: order)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}

class orderbutton extends StatefulWidget {
  const orderbutton({
    super.key,
    required this.cart,
    required this.order,
  });

  final Cart cart;
  final Order order;

  @override
  State<orderbutton> createState() => _orderbuttonState();
}

class _orderbuttonState extends State<orderbutton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalamount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.order.addorder(
                  widget.cart.items.values.toList(), widget.cart.totalamount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "Order Now",
              style: TextStyle(color: Colors.purple),
            ),
    );
  }
}
