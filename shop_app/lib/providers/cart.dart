import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../util/constants.dart';
import 'dart:convert';

class CartItem {
  final String userId;
  final int quantity;
  final double price;
  final String title;
  final String imageUrl;
  final String description;

  CartItem({
    required this.userId,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItem = {};
  String _token = "";
  String _userId = "";

  Cart(this._token, this._cartItem, this._userId);

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

  Future<String> _getCartItemId(String id) async {
    var getUrl = Uri(
        scheme: 'https',
        host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
        path: '/cartitem/$_userId.json',
        queryParameters: {
          "auth": _token,
          "orderBy": "\"userId\"",
          "equalTo": "\"$id\""
        });
    var getResponse = await http.get(getUrl);
    var cartItemId = json.decode(getResponse.body) as Map<String, dynamic>;
    return cartItemId.isNotEmpty ? cartItemId.keys.first : "";
  }

  Future<void> addItem(String id, double price, String imageUrl,
      String description, String title,
      {int quantity = 1}) async {
    try {
      var cartItemId = await _getCartItemId(id);
      if (cartItemId != "" && _cartItem.containsKey(cartItemId)) {
        var url = Uri(
            scheme: 'https',
            host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
            path: '/cartitem/$_userId/$cartItemId.json',
            queryParameters: {
              "auth": _token,
            });
        var cartItemQuantity = 0;
        _cartItem.forEach((key, value) => key == cartItemId
            ? cartItemQuantity = value.quantity
            : cartItemQuantity = 1);
        var response = await http.patch(url,
            body: json.encode({
              "quantity": cartItemQuantity + quantity,
            }));
        if (response.statusCode == 200) {
          _cartItem.update(
              cartItemId,
              (value) => CartItem(
                  userId: value.userId,
                  description: value.description,
                  imageUrl: imageUrl,
                  price: price,
                  quantity: value.quantity + quantity,
                  title: value.title));
          notifyListeners();
        } else {
          throw Exception();
        }
      } else {
        var url = Uri(
            scheme: 'https',
            host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
            path: '/cartitem/$_userId.json',
            queryParameters: {"auth": _token});
        var response = await http.post(url,
            body: json.encode({
              "userId": id,
              "description": description,
              "imageUrl": imageUrl,
              "price": price,
              "quantity": quantity,
              "title": title
            }));
        if (response.statusCode == 200) {
          _cartItem.putIfAbsent(
              json.decode(response.body)["name"],
              () => CartItem(
                  userId: id,
                  description: description,
                  imageUrl: imageUrl,
                  price: price,
                  quantity: quantity,
                  title: title));
          notifyListeners();
        } else {
          throw Exception();
        }
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> getCartItem() async {
    try {
      var url = Uri(
          scheme: 'https',
          host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
          path: '/cartitem/$_userId.json',
          queryParameters: {"auth": _token});
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var loadedData = json.decode(response.body) as Map<String, dynamic>;
        if (loadedData != null) {
          loadedData.forEach((key, value) => _cartItem[key] = CartItem(
              userId: key,
              description: value["description"],
              imageUrl: value["imageUrl"],
              price: value["price"],
              quantity: value["quantity"],
              title: value["title"]));
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteItem(String cartItemId) async {
    try {
      var url = Uri(
          scheme: 'https',
          host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
          path: '/cartitem/$_userId/$cartItemId.json',
          queryParameters: {"auth": _token});
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        _cartItem.remove(cartItemId);
        notifyListeners();
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> clearCart() async {
    try {
      var url = Uri(
          scheme: 'https',
          host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
          path: '/cartitem/$_userId.json',
          queryParameters: {"auth": _token});
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        _cartItem = {};
        notifyListeners();
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }
}
