import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final int quantity;
  final double price;
  final String productId;
  const CartItem(
      {Key? key,
      required this.description,
      required this.id,
      required this.imageUrl,
      required this.price,
      required this.quantity,
      required this.title,
      required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteItem = Provider.of<Cart>(context).deleteItem;
    return Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          deleteItem(productId);
        },
        background: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.centerRight,
          color: Theme.of(context).colorScheme.error,
          child: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
        child: Card(
          child: ListTile(
            leading: FittedBox(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(title),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description),
                Text(
                  "rs $price",
                  style: const TextStyle(fontSize: 12.0),
                )
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text("$quantity X"),
                Text("Total: \$${(price * quantity)}")
              ],
            ),
          ),
        ));
  }
}