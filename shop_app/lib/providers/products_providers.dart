import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(
        id: "1",
        description: 'Cricket Stud shoes for men',
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-EOvLlbEMAjT5tJWWrgHABJDzepebWK9zqQ&usqp=CAU",
        price: 540,
        title: "Cricket Stud Shoes",
        isFavourite: false),
    Product(
        id: "2",
        description: 'Cricket Stud shoes for men',
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFS4BrgAhpXlCnfgSnQ78rxZxhbA9fc6iY3g&usqp=CAU",
        price: 540,
        title: "Cricket Stud Shoes",
        isFavourite: true),
    Product(
        id: "3",
        description: 'Cricket Stud shoes for men',
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRs6Q1ZoAm-aw2ehInLqKbMkuEud4tpo2qG7g&usqp=CAU",
        price: 540,
        title: "Cricket Stud Shoes",
        isFavourite: true),
    Product(
        id: "4",
        description: 'Cricket Stud shoes for men',
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjunGdaLPiB0xd-Lhw9frcbgeEZgLLdYkERg&usqp=CAU",
        price: 540,
        title: "Cricket Stud Shoes",
        isFavourite: false)
  ];

  List<Product> get getItems {
    return [..._items];
  }

  List<Product> get favouuriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
