import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String proid;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id, this.proid, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to remove the item from the cart?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes"))
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cart.remove_item(proid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: FittedBox(child: Text("₹$price"))),
            ),
            title: Text(title),
            subtitle: Text("₹${(price * quantity)}"),
            trailing: Text("$quantity *"),
          ),
        ),
      ),
    );
  }
}
