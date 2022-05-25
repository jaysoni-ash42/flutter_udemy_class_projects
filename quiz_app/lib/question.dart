import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionTitle;

  const Question({Key? key, required this.questionTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Text(
          questionTitle,
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
          softWrap: true,
        ));
  }
}
