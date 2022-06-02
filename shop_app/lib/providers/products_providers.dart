import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/util/helper.dart';

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

  void addProduct(Product product, BuildContext context) {
    final newProduct = Product(
        image: product.image,
        description: product.description,
        id: DateTime.now().toString(),
        price: product.price,
        title: product.title);
    _items.add(newProduct);
    showToast(context, "Product Added");

    notifyListeners();
  }

  void updateProducts(Product newProduct, BuildContext context) {
    final indexNumber = _items.indexWhere((prod) => prod.id == newProduct.id);
    if (indexNumber >= 0) {
      _items[indexNumber] = newProduct;
      showToast(context, "Product Updated");
      notifyListeners();
    } else {
      showToast(context, "Product Not Found",
          iconColor: Colors.redAccent, icon: Icons.cancel_rounded);
    }
  }

  void deleteProduct(String id, BuildContext context) {
    final indexNumber = _items.indexWhere((prod) => prod.id == id);
    if (indexNumber >= 0) {
      _items.removeAt(indexNumber);
      showToast(context, "Product Deleted");
      notifyListeners();
    } else {
      showToast(context, "Product Not Found",
          iconColor: Colors.redAccent, icon: Icons.cancel_rounded);
    }
    Navigator.of(context).pop(true);
  }
}
