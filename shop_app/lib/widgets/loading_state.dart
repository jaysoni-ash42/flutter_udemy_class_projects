import "package:flutter/material.dart";

class LoadingState extends StatelessWidget {
  const LoadingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey),
        padding: const EdgeInsets.all(10),
        child: const Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.blueGrey,
          color: Colors.white,
        )));
  }
}
