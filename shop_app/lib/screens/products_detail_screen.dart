import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_providers.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<ProductProvider>(context, listen: true).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Text(loadedProduct.title)),
    );
  }
}
