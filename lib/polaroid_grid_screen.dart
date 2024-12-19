import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PolaroidGridScreen extends StatelessWidget {
  final List<Map<String, dynamic>> polaroidData = [
    {
      'image': 'assets/images/january.png',
      'caption': 'January ',
      'video': 'assets/videos/january.mp4',
    },
    {
      'image': 'assets/images/february.png',
      'caption': 'February ',
      'video': 'assets/videos/february.mp4',
    },
    {
      'image': 'assets/images/march.png',
      'caption': 'March ',
      'video': '',
    },
    {
      'image': 'assets/images/april.png',
      'caption': 'April ',
      'video': 'assets/videos/april.mp4',
    },
    {
      'image': 'assets/images/may.png',
      'caption': 'May',
      'video': 'assets/videos/may.mp4',
    },
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
        'image': 'assets/images/placeholder.jpg',
        'caption': monthNames[index],
        'video': '',
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 items per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: polaroidData.length,
        itemBuilder: (context, index) {
          final item = polaroidData[index];
          return PolaroidCard(
            imagePath: item['image'] ?? '',
            caption: item['caption'] ?? '',
            videoPath: item['video'] ?? '',
          );
        },
      ),
    );
  }
}

class PolaroidCard extends StatefulWidget {
  final String imagePath;
  final String videoPath;
  final String? caption;

  const PolaroidCard({
    Key? key,
    required this.imagePath,
    required this.videoPath,
    this.caption,
  }) : super(key: key);

  @override
  _PolaroidCardState createState() => _PolaroidCardState();
}

class _PolaroidCardState extends State<PolaroidCard> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize video if provided
    if (widget.videoPath.isNotEmpty) {
      _videoController = VideoPlayerController.asset(widget.videoPath)
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        }).catchError((e) {
          debugPrint('Video player initialization error: $e');
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white, // White foundation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.videoPath.isNotEmpty && _isVideoInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(_videoController!),
                        const Icon(
                          Icons.play_circle_fill,
                          size: 40,
                          color: Colors.white,
                        ),
                      ],
                    )
                  : Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          // Caption
          if (widget.caption != null)
            Text(
              widget.caption!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
        ],
      ),
    );
  }
}
