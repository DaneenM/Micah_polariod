import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 3 / 4, // Fixed aspect ratio for Polaroid cards
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.videoPath.isNotEmpty && _isVideoInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_videoController!),
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill,
                            size: 40, color: Colors.white),
                        onPressed: () => _videoController?.play(),
                      ),
                    ],
                  )
                : Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image,
                          size: 40, color: Colors.grey),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        if (widget.caption != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              widget.caption!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
    );
  }
}

class PolaroidGridScreen extends StatelessWidget {
  final List<Map<String, dynamic>> polaroidData = [
    {
      'image': 'assets/images/january.png',
      'video': 'assets/videos/january.mp4',
      'caption': 'January'
    },
    {
      'image': 'assets/images/february.png',
      'video': 'assets/videos/february.mp4',
      'caption': 'February'
    },
    {'image': 'assets/images/march.png', 'video': '', 'caption': 'March'},
    {
      'image': 'assets/images/april.png',
      'video': 'assets/videos/april.mp4',
      'caption': 'April'
    },
    {
      'image': 'assets/images/may.png',
      'video': 'assets/videos/may.mp4',
      'caption': 'May'
    },
    ...List.generate(7, (index) {
      final monthNames = [
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return {
        'image': 'assets/images/placeholder.jpg',
        'video': '',
        'caption': monthNames[index]
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
          childAspectRatio: 0.85, // Adjust for caption spacing
        ),
        itemCount: polaroidData.length,
        itemBuilder: (context, index) {
          final item = polaroidData[index];
          return PolaroidCard(
            imagePath: item['image'] ?? '',
            videoPath: item['video'] ?? '',
            caption: item['caption'] ?? '',
          );
        },
      ),
    );
  }
}
