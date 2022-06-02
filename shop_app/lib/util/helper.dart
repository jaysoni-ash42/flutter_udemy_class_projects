import 'package:flutter/material.dart';

void showToast(BuildContext context, String toast,
    {IconData icon = Icons.check_circle_rounded,
    Color iconColor = Colors.greenAccent}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
        content:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(
            icon,
            color: iconColor,
          ),
          Text(
            toast,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: "Poppins"),
          )
        ]),
        backgroundColor: Colors.black54,
        duration: const Duration(seconds: 2)),
  );
}
