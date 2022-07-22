import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/util/constants.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];
  String _token = "";
  String _userId = "";

  ProductProvider(this._token, this._items, this._userId);

  List<Product> get getItems {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<bool> getProduct(bool fetchOwnProduct) async {
    var url = Uri(
        scheme: 'https',
        host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
        path: '/product.json',
        queryParameters: fetchOwnProduct
            ? {
                "auth": _token,
                "orderBy": "\"creatorId\"",
                "equalTo": "\"$_userId\""
              }
            : {"auth": _token});
    var favouriteUrl = Uri(
        scheme: 'https',
        host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
        path: '/userFavourite/$_userId.json',
        queryParameters: {"auth": _token});
    try {
      var favouriteResponse = await http.get(favouriteUrl);
      var response = await http.get(url);
      if (response.statusCode == 200 && favouriteResponse.statusCode == 200) {
        var products = json.decode(response.body) as Map<String, dynamic>;
        var favouriteData = json.decode(favouriteResponse.body);
        List<Product> responseData = [];
        if (products.isEmpty) {
          return false;
        }
        products.forEach((key, value) {
          responseData.add(Product(
              image: value["image"],
              description: value["description"],
              id: key,
              price: value["price"],
              title: value["title"],
              isFavourite:
                  favouriteData == null ? false : favouriteData[key] ?? false));
        });
        _items = responseData;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addProduct(Product product) async {
    var url = Uri(
        scheme: 'https',
        host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
        path: '/product.json',
        queryParameters: {"auth": _token});

    try {
      var response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "image": product.image,
            "creatorId": _userId
          }));
      if (response.statusCode == 200) {
        final newProduct = Product(
            image: product.image,
            description: product.description,
            id: json.decode(response.body)["name"].toString(),
            price: product.price,
            title: product.title);
        _items.add(newProduct);
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProducts(Product newProduct) async {
    final indexNumber = _items.indexWhere((prod) => prod.id == newProduct.id);
    if (indexNumber >= 0) {
      var url = Uri(
          scheme: 'https',
          host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
          path: '/product/${newProduct.id}.json',
          queryParameters: {"auth": _token});
      try {
        var response = await http.patch(url,
            body: json.encode({
              "title": newProduct.title,
              "description": newProduct.description,
              "price": newProduct.price,
              "image": newProduct.image,
            }));
        if (response.statusCode == 200) {
          _items[indexNumber] = newProduct;
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    final indexNumber = _items.indexWhere((prod) => prod.id == id);
    if (indexNumber >= 0) {
      var url = Uri(
          scheme: 'https',
          host: dotenv.env[FIRE_BASE_REALTIME_DATABASE_URI],
          path: '/product/$id.json',
          queryParameters: {"auth": _token});
      try {
        var response = await http.delete(url);
        if (response.statusCode == 200) {
          _items.removeAt(indexNumber);
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }
}
