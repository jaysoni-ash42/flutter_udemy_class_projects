import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/order.dart' show Order;
import '../widgets/loading_state.dart';
import '../widgets/order_item.dart';
import '../widgets/refresh_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late bool _loadingState;
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future init() async {
    setState(() {
      _loadingState = true;
    });
    try {
      await Provider.of<Order>(context, listen: false).getOrder();
      setState(() {
        _loadingState = false;
      });
    } catch (e) {
      setState(() {
        _loadingState = false;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      _loadingState = true;
    });
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context).orderItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: _loadingState
          ? const Center(child: LoadingState())
          : RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: init,
              child: ListView.builder(
                itemCount: orderData.length,
                itemBuilder: (ctx, i) => OrderItem(order: orderData[i]),
              )),
    );
  }
}
