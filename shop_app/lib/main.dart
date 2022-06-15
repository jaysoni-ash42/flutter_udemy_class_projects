import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/providers/products_providers.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/products_detail_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import 'package:shop_app/util/constants.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Auth()),
      ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: (_) => ProductProvider("", [], ""),
          update: (ctx, auth, previousProduct) => ProductProvider(
                auth.token,
                previousProduct!.getItems.isEmpty
                    ? []
                    : previousProduct.getItems,
                auth.userId,
              )),
      ChangeNotifierProxyProvider<Auth, Cart>(
          create: (_) => Cart("", {}, ""),
          update: (ctx, auth, cartPrevious) =>
              Cart(auth.token, cartPrevious!.getCartItems, auth.userId)),
      ChangeNotifierProxyProvider<Auth, Order>(
          create: (_) => Order("", [], ""),
          update: (ctx, auth, previousOrder) => Order(
              auth.token,
              previousOrder!.orderItems.isEmpty ? [] : previousOrder.orderItems,
              auth.userId))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
        builder: ((context, value, child) => MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
                          .copyWith(secondary: Colors.orangeAccent)
                          .copyWith(error: Colors.redAccent),
                  fontFamily: "poppins"),
              home: value.isAuth
                  ? const ProductOverviewScreen()
                  : FutureBuilder(
                      future: value.tryAutoLogin(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen()),
              routes: {
                PRODUCT_DETAIL_PAGE_ROUTE_NAME: (context) =>
                    const ProductDetailScreen(),
                CART_ITEMS_PAGE_ROUTE_NAME: (context) => const CartScreen(),
                ORDER_PAGE_ROUTE_NAME: (context) => const OrdersScreen(),
                USER_PRODUCT_PAGE_ROUTE_NAME: (context) =>
                    const UserProductScreen(),
                EDIT_PRODUCT_PAGE_ROUTE_NAME: (context) =>
                    const ProductEditScreen()
              },
            )));
  }
}
