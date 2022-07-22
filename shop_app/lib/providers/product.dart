import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../util/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  bool isFavourite;

  void toggleFavourite(String token, String userId) async {
    final oldStatus = isFavourite;
    var url = Uri(
        scheme: 'https',
        host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
        path: '/userFavourite/$userId/$id.json',
        queryParameters: {"auth": token});
    try {
      var response = await http.put(url, body: json.encode(!isFavourite));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
        return;
      }
      isFavourite = !isFavourite;
      notifyListeners();
    } catch (e) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }

  Product(
      {required this.image,
      required this.description,
      required this.id,
      required this.price,
      required this.title,
      this.isFavourite = false});
}
