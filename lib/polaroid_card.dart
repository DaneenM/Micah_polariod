import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PolaroidCard extends StatefulWidget {
  final String imagePath;
  final String videoPath;
  final String? caption;
  final List<String>? messages; // Optional sliding text
  final List<String>? images; // List of images for slideshow

  const PolaroidCard({
    Key? key,
    required this.imagePath,
    required this.videoPath,
    this.caption,
    this.messages,
    this.images,
  }) : super(key: key);

  @override
  _PolaroidCardState createState() => _PolaroidCardState();
}

class _PolaroidCardState extends State<PolaroidCard> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath.isNotEmpty) {
      _videoController = VideoPlayerController.asset(widget.videoPath)
        ..initialize().then((_) {
          setState(() {});
        }).catchError((e) {
          debugPrint('Video player initialization error: $e');
        });
    }
  }

  @override
  void dispose() {
    if (widget.videoPath.isNotEmpty) {
      _videoController.dispose();
    }
    super.dispose();
  }

  void _openFullScreen(BuildContext context) {
    if (widget.videoPath.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenVideo(videoPath: widget.videoPath),
        ),
      );
    } else if (widget.imagePath.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImage(imagePath: widget.imagePath),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullScreen(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120, // Adjusted size for smaller cards
            width: 100, // Adjusted size for smaller cards
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.videoPath.isNotEmpty
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController.value.isInitialized
                              ? _videoController.value.aspectRatio
                              : 16 / 9,
                          child: VideoPlayer(_videoController),
                        ),
                        const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    )
                  : Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          if (widget.caption != null)
            Text(
              widget.caption!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class FullScreenVideo extends StatefulWidget {
  final String videoPath;

  const FullScreenVideo({Key? key, required this.videoPath}) : super(key: key);

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Playing Video"),
      ),
      body: Center(
        child: _videoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            : const CircularProgressIndicator(),
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_videoController.value.isPlaying) {
              _videoController.pause();
            } else {
              _videoController.play();
            }
          });
        },
        child: Icon(
          _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Viewing Image"),
      ),
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
