import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_providers.dart';
import 'package:shop_app/util/constants.dart';

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
      trailing: Container(
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
                                  onPressed: () {
                                    Provider.of<ProductProvider>(context,
                                            listen: false)
                                        .deleteProduct(id, context);
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
