import "package:flutter/material.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
          "https://cdn.dribbble.com/users/2015153/screenshots/6592242/progess-bar2.gif",
          fit: BoxFit.cover),
    );
  }
}
