import 'package:flutter/material.dart';

class FullScreenImageSlideshow extends StatelessWidget {
  final List<String> images;

  const FullScreenImageSlideshow({Key? key, required this.images})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.asset(
            images[index],
            fit: BoxFit.contain,
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
