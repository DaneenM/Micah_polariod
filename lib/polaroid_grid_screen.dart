import 'package:flutter/material.dart';
import 'polaroid_card.dart';

class PolaroidGridScreen extends StatelessWidget {
  final List<Map<String, dynamic>> polaroidData = [
    {
      'image': 'assets/images/january.jpg',
      'caption': 'January',
      'video': 'assets/videos/january.mp4',
    },
    {
      'image': 'assets/images/february.jpg',
      'caption': 'February',
      'video': 'assets/videos/february.mp4',
    },
    {
      'images': [
        'assets/images/march1.png',
        'assets/images/march2.png',
        'assets/images/march3.png',
        'assets/videos/march.mp4',
      ],
      'caption': 'March',
      'video': '',
    },
    {
      'image': 'assets/images/april.jpg',
      'caption': 'April',
      'video': 'assets/videos/april.mp4',
    },
    {
      'image': 'assets/images/may.jpg',
      'caption': 'May',
      'video': 'assets/videos/may.mp4',
    },
    // Placeholder data for the rest of the months
    ...List.generate(7, (index) {
      final monthNames = [
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return {
        'image': 'assets/images/placeholder.jpg', // Placeholder image
        'caption': monthNames[index],
        'video': '', // Empty video path as a placeholder
      };
    }),
  ];

  PolaroidGridScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Year in Polaroids',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 120, // Adjusted size for smaller cards
          crossAxisSpacing: 24, // Increased spacing between columns
          mainAxisSpacing: 24, // Increased spacing between rows
          childAspectRatio: 0.7, // Maintain alignment
        ),
        itemCount: polaroidData.length,
        itemBuilder: (context, index) {
          final item = polaroidData[index];
          return PolaroidCard(
            imagePath: item['image'] ?? '',
            caption: item['caption'] ?? '',
            videoPath: item['video'] ?? '',
            images:
                item['images'] as List<String>?, // Keep only valid parameters
          );
        },
      ),
    );
  }
}
