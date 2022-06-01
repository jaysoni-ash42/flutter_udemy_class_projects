import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final int quantity;
  final double price;
  final String title;
  final String imageUrl;
  final String description;

  CartItem(
      {required this.id,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.quantity,
      required this.title});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItem = {};

  Map<String, CartItem> get getCartItems {
    return {..._cartItem};
  }

  int get totalCartItems {
    return _cartItem.length;
  }

  double get totalAmount {
    var totalCount = 0.0;
    _cartItem.forEach((key, value) {
      totalCount += value.price * value.quantity;
    });
    return totalCount;
  }

  void addItem(String id, double price, String imageUrl, String description,
      String title,
      {int quantity = 1}) {
    if (_cartItem.containsKey(id)) {
      _cartItem.update(
          id,
          (value) => CartItem(
              id: id,
              description: value.description,
              imageUrl: imageUrl,
              price: price,
              quantity: value.quantity + quantity,
              title: value.title));
    } else {
      _cartItem.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              description: description,
              imageUrl: imageUrl,
              price: price,
              quantity: quantity,
              title: title));
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    _cartItem.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItem = {};
    notifyListeners();
  }
}
