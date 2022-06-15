import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/util/helper.dart';
import 'package:shop_app/widgets/loading_state.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final totalAmount = Provider.of<Cart>(context).totalAmount;
    final totalItems = Provider.of<Cart>(context).totalCartItems;
    final cart = Provider.of<Cart>(context).getCartItems;
    final clearCart = Provider.of<Cart>(context).clearCart;
    final addOrder = Provider.of<Order>(context).addOrder;
    var _loadingState = false;
    return Scaffold(
        appBar: AppBar(title: const Text("My Cart")),
        body: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:", style: TextStyle(fontSize: 20)),
                        const Spacer(),
                        Chip(
                          label: Text("Rs ${totalAmount.toStringAsFixed(1)}"),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        TextButton(
                            onPressed: totalAmount <= 0.0 || _loadingState
                                ? null
                                : () async {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    setState(() {
                                      _loadingState = true;
                                    });
                                    try {
                                      await addOrder(
                                          cart.values.toList(), totalAmount);
                                      await clearCart();
                                      setState(() {
                                        _loadingState = false;
                                      });
                                      showToast(context,
                                          "Check Order Screen to Place the order");
                                    } catch (e) {
                                      setState(() {
                                        _loadingState = false;
                                      });
                                      showToast(context, "Something Went wrong",
                                          icon: Icons.cancel_rounded,
                                          iconColor: Colors.redAccent);
                                    }
                                  },
                            child: _loadingState
                                ? const LoadingState()
                                : const Text(
                                    "Order Now",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: totalItems,
                        itemBuilder: (ctx, i) => CartItem(
                              id: cart.values.toList()[i].userId,
                              description: cart.values.toList()[i].description,
                              imageUrl: cart.values.toList()[i].imageUrl,
                              price: cart.values.toList()[i].price,
                              quantity: cart.values.toList()[i].quantity,
                              title: cart.values.toList()[i].title,
                              productId: cart.keys.toList()[i],
                            )))
              ],
            )));
  }
}
