import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_providers.dart';
import 'package:shop_app/util/constants.dart';

import '../util/helper.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  const UserProductItem(
      {Key? key,
      required this.id,
      required this.imageUrl,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(imageUrl, fit: BoxFit.cover),
      title: Text(title),
      subtitle: Text(description),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EDIT_PRODUCT_PAGE_ROUTE_NAME, arguments: id);
                },
                icon: const Icon(
                  Icons.edit_outlined,
                )),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: const Text("Are You Sure?"),
                            content: const Text(
                                "Do you want to remove the item from the cart?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("No")),
                              ElevatedButton(
                                  onPressed: () async {
                                    var state =
                                        await Provider.of<ProductProvider>(
                                                context,
                                                listen: false)
                                            .deleteProduct(id);
                                    if (state) {
                                      showToast(
                                        context,
                                        "Product Deleted",
                                      );
                                    } else {
                                      showToast(context,
                                          "Product Not Found Try Again",
                                          iconColor: Colors.redAccent,
                                          icon: Icons.cancel_rounded);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Yes"))
                            ],
                          ));
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red[300],
                ))
          ],
        ),
      ),
    );
  }
}
