import 'package:flutter/material.dart';
import 'polaroid_card.dart';

class PolaroidGridScreen extends StatelessWidget {
  final List<Map<String, dynamic>> polaroidData = [
    {
      'image': 'assets/images/january.jpg',
      'caption': 'Where us began ❤️ ',
      'video': 'assets/videos/january.mp4'
    },
    {
      'image': 'assets/images/february.jpg',
      'caption': 'Laughs we’ll never forget',
      'video': 'assets/videos/february.mp4'
    },
    {
      'images': [
        'assets/images/march1.png',
        'assets/images/march2.png',
        'assets/images/march3.png',
        'assets/videos/march.mp4'
      ],
      'messages': [
        'Message 1: A day to remember!',
        'Message 2: We laughed so much here!',
        'Message 3: I’ll never forget this day ❤️'
            'Message 3: I’ll never forget this day ❤️'
      ],
      'video': ''
    },
    {
      'image': 'assets/images/may.jpg',
      'caption': 'Blooming moments 🌸',
      'video': 'assets/videos/may.mp4'
    },
  ];

  PolaroidGridScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Our Year in Polaroids')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: polaroidData.length,
        itemBuilder: (context, index) {
          final item = polaroidData[index];
          return PolaroidCard(
            imagePath: item['image'] ?? '',
            caption: item['caption'] ?? '',
            videoPath: item['video'] ?? '',
            messages: item['messages'] as List<String>?,
            images: item['images'] as List<String>?,
          );
        },
      ),
    );
  }
}
