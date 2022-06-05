import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_providers.dart';
import 'package:shop_app/util/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/loading_state.dart';
import 'package:shop_app/widgets/refresh_widget.dart';
import 'package:shop_app/widgets/user_list_item.dart';

class UserProductScreen extends StatefulWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future _refetchData(BuildContext context) async {
    keyRefresh.currentState?.show();
    await Provider.of<ProductProvider>(context, listen: false).getProduct(true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
          future: _refetchData(context),
          builder: (ctx, snapshot) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: LoadingState())
                  : RefreshWidget(
                      keyRefresh: keyRefresh,
                      onRefresh: () => _refetchData(context),
                      child: Consumer<ProductProvider>(
                          builder: (ctx, productProvider, child) =>
                              ListView.builder(
                                  itemCount: productProvider.getItems.length,
                                  itemBuilder: (ctx, i) => Column(children: [
                                        UserProductItem(
                                          id: productProvider.getItems[i].id,
                                          title:
                                              productProvider.getItems[i].title,
                                          description: productProvider
                                              .getItems[i].description,
                                          imageUrl:
                                              productProvider.getItems[i].image,
                                        ),
                                        const Divider(),
                                      ])))))),
    );
  }
}
