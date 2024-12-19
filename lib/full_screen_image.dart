import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
