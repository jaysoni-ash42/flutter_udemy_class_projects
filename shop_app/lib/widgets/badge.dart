import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class Badge extends StatelessWidget {
  final Widget child;

  const Badge({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalItems = Provider.of<Cart>(context).totalCartItems;
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
            right: 8,
            top: 6,
            child: totalItems > 0
                ? Container(
                    padding: const EdgeInsets.all(1.0),
                    // color: Theme.of(context).accentColor,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 12,
                    ),
                    child: Text(
                      totalItems.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  )
                : const SizedBox(width: 0, height: 0))
      ],
    );
  }
}
