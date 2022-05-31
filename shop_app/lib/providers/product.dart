import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  bool isFavourite;

  void toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }

  Product(
      {required this.image,
      required this.description,
      required this.id,
      required this.price,
      required this.title,
      this.isFavourite = false});
}
