import 'package:flutter/material.dart';
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

  void toggleFavourite() async {
    final oldStatus = isFavourite;
    var url = Uri(
      scheme: 'https',
      host: FIRE_BASE_REALTIME_DATABASE_URI,
      path: '/product/$id.json',
    );
    try {
      var response = await http.patch(url,
          body: json.encode({"isFavourite": !isFavourite}));
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
