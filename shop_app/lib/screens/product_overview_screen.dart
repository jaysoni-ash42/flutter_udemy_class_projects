import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_providers.dart';
import 'package:shop_app/util/constants.dart';
import 'package:shop_app/util/enum.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/loading_state.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/refresh_widget.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavourite = false;
  bool _loadingState = true;
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future init() async {
    keyRefresh.currentState?.show();
    setState(() {
      _loadingState = true;
    });
    var state = await Provider.of<ProductProvider>(context, listen: false)
        .getProduct(false);
    if (state == true) {
      setState(() {
        _loadingState = false;
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop App"),
        actions: <Widget>[
          Badge(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CART_ITEMS_PAGE_ROUTE_NAME);
                  },
                  icon: const Icon(Icons.shopping_cart))),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: ProductOverViewAppBarEnum.favourites,
                  child: Text("Only Favourites")),
              const PopupMenuItem(
                  value: ProductOverViewAppBarEnum.all, child: Text("Show All"))
            ],
            onSelected: (ProductOverViewAppBarEnum selectedItem) {
              setState(() {
                if (selectedItem == ProductOverViewAppBarEnum.favourites) {
                  _showFavourite = true;
                } else {
                  _showFavourite = false;
                }
              });
            },
          )
        ],
      ),
      body: _loadingState
          ? const Center(child: LoadingState())
          : RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: init,
              child: ProductGrid(
                showFavourite: _showFavourite,
              )),
      drawer: const AppDrawer(),
    );
  }
}
