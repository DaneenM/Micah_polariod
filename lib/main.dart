import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Year in Polaroids',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'DancingScript', // Handwritten-style font
      ),
      home: HomeScreen(),
    );
  }
}
