import 'dart:math';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

import '../providers/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
                'Total Amount: Rs ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              "Order Date: ${DateFormat('dd/MM/yyyy').format(widget.order.dispatchTime)}",
            ),
            trailing: IconButton(
              icon: _expanded
                  ? const Icon(Icons.expand_less)
                  : const Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                height: min(widget.order.item.length * 20 + 20, 180),
                child: ListView(
                  children: widget.order.item
                      .map((data) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "${data.quantity} X Price: \$${data.price.toStringAsFixed(2)}")
                            ],
                          ))
                      .toList(),
                ))
        ],
      ),
    );
  }
}
