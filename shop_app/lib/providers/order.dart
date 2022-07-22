import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import '../util/constants.dart';
import 'dart:convert';

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
  List<OrderItem> _orderItem = [];
  String _token = "";
  String _userId = "";

  Order(this._token, this._orderItem, this._userId);

  List<OrderItem> get orderItems {
    return [..._orderItem];
  }

  Future<void> addOrder(List<CartItem> cartItem, double amount) async {
    final date = DateTime.now();
    var url = Uri(
        scheme: 'https',
        host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
        path: '/orders/$_userId.json',
        queryParameters: {"auth": _token});

    try {
      var response = await http.post(url,
          body: json.encode({
            "dispatchTime": date.toIso8601String(),
            "amount": amount,
            "item": cartItem
                .map((element) => {
                      "id": element.userId,
                      "quantity": element.quantity,
                      "title": element.title,
                      "description": element.description,
                      "imageUrl": element.imageUrl,
                      "price": element.price
                    })
                .toList()
          }));
      if (response.statusCode == 200) {
        _orderItem.add(OrderItem(
            dispatchTime: DateTime.now(),
            amount: amount,
            id: json.decode(response.body)["name"],
            item: cartItem));
        notifyListeners();
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> getOrder() async {
    List<OrderItem> loadedProducts = [];
    var url = Uri(
        scheme: 'https',
        host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
        path: '/orders/$_userId.json',
        queryParameters: {"auth": _token});
    try {
      var response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        if (extractedData.isEmpty) {
          return;
        }
        extractedData.forEach((key, value) => {
              loadedProducts.add(OrderItem(
                  dispatchTime: DateTime.parse(value["dispatchTime"]),
                  amount: value["amount"],
                  id: key,
                  item: (value["item"] as List<dynamic>)
                      .map((element) => CartItem(
                          description: element["description"],
                          userId: element["id"],
                          imageUrl: element["imageUrl"],
                          price: element["price"],
                          quantity: element["quantity"],
                          title: element["title"]))
                      .toList()))
            });
        _orderItem = loadedProducts.reversed.toList();
        notifyListeners();
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }
}
