import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/providers/products_providers.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/products_detail_screen.dart';
import 'package:shop_app/util/constants.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => Cart()),
      ChangeNotifierProvider(create: (_) => Order())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
              .copyWith(secondary: Colors.orangeAccent)
              .copyWith(error: Colors.redAccent),
          fontFamily: "poppins"),
      home: const ProductOverviewScreen(),
      routes: {
        PRODUCT_DETAIL_PAGE_ROUTE_NAME: (context) =>
            const ProductDetailScreen(),
        CART_ITEMS_PAGE_ROUTE_NAME: (context) => const CartScreen(),
        ORDER_PAGE_ROUTE_NAME: (context) => const OrdersScreen()
      },
    );
  }
}
