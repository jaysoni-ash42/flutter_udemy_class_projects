import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_providers.dart';
import 'package:shop_app/util/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_list_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context).getItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EDIT_PRODUCT_PAGE_ROUTE_NAME);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: productData.length,
              itemBuilder: (ctx, i) => Column(children: [
                    UserProductItem(
                      id: productData[i].id,
                      title: productData[i].title,
                      description: productData[i].description,
                      imageUrl: productData[i].image,
                    ),
                    const Divider(),
                  ]))),
    );
  }
}
