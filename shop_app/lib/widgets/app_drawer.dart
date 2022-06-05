import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/util/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text("Ecommerce shop App"),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text("Shop"),
          onTap: () {
            Navigator.of(context).pushNamed("/");
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text("Orders"),
          onTap: () {
            Navigator.of(context).pushNamed(ORDER_PAGE_ROUTE_NAME);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit_note_rounded),
          title: const Text("Manage Products"),
          onTap: () {
            Navigator.of(context).pushNamed(USER_PRODUCT_PAGE_ROUTE_NAME);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: const Text("Log Out"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/");
            Provider.of<Auth>(context, listen: false).logOut();
          },
        ),
      ]),
    );
  }
}
