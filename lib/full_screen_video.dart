import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
      appBar: AppBar(backgroundColor: Colors.black),
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
