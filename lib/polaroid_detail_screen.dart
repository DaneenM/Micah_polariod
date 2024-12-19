import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PolaroidDetailScreen extends StatefulWidget {
  final String videoPath;

  const PolaroidDetailScreen({super.key, required this.videoPath});

  @override
  _PolaroidDetailScreenState createState() => _PolaroidDetailScreenState();
}

class _PolaroidDetailScreenState extends State<PolaroidDetailScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with the provided video path
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {}); // Rebuild the widget to display the video
        _controller.setVolume(1.0); // Ensure the video sound is enabled
        _controller.play(); // Automatically start playing the video
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polaroid View'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(), // Loading indicator while the video initializes
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
