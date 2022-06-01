import 'package:flutter/material.dart';

void showToast(BuildContext context, String itemName) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
        content:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Icon(
            Icons.check_box_rounded,
            color: Colors.white,
          ),
          Text(
            "$itemName added to Cart",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Poppins"),
          )
        ]),
        backgroundColor: Colors.black54,
        duration: const Duration(milliseconds: 250)),
  );
}
