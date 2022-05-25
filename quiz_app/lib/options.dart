import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  final String optionsTitle;
  final VoidCallback optionsPressed;

  const Options(
      {Key? key, required this.optionsTitle, required this.optionsPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: optionsPressed,
          child: Text(optionsTitle),
        ));
  }
}
