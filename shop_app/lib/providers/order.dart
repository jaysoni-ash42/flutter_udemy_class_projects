import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dispatchTime;
  final List<CartItem> item;

  OrderItem(
      {required this.dispatchTime,
      required this.amount,
      required this.id,
      required this.item});
}

class Order with ChangeNotifier {
  final List<OrderItem> _orderItem = [];

  List<OrderItem> get orderItems {
    return [..._orderItem];
  }

  void addOrder(List<CartItem> cartItem, double amount) {
    _orderItem.add(OrderItem(
        dispatchTime: DateTime.now(),
        amount: amount,
        id: DateTime.now().toString(),
        item: cartItem));
    notifyListeners();
  }
}
