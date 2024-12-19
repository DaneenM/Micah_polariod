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
  int _currentMessageIndex = 0; // Track the current sliding message

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

    // Start sliding text if messages are provided
    if (widget.messages != null && widget.messages!.isNotEmpty) {
      Future.delayed(const Duration(seconds: 2), _slideMessages);
    }
  }

  void _slideMessages() {
    if (widget.messages != null && widget.messages!.isNotEmpty) {
      setState(() {
        _currentMessageIndex =
            (_currentMessageIndex + 1) % widget.messages!.length;
      });
      Future.delayed(const Duration(seconds: 2), _slideMessages);
    }
  }

  @override
  void dispose() {
    if (widget.videoPath.isNotEmpty) {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.images != null && widget.images!.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ImageSlideshowScreen(images: widget.images!),
            ),
          );
        } else if (widget.videoPath.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoScreen(videoPath: widget.videoPath),
            ),
          );
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: widget.images != null && widget.images!.isNotEmpty
                    ? PageView.builder(
                        itemCount: widget.images!.length,
                        itemBuilder: (context, index) {
                          final isVideo =
                              widget.images![index].endsWith('.mp4');
                          return isVideo
                              ? VideoPlayerWidget(
                                  videoPath: widget.images![index])
                              : Image.asset(
                                  widget.images![index],
                                  fit: BoxFit.cover,
                                );
                        },
                      )
                    : widget.videoPath.isNotEmpty
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                              const Icon(Icons.play_circle_fill,
                                  size: 50, color: Colors.white),
                            ],
                          )
                        : Image.asset(widget.imagePath, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              if (widget.messages != null && widget.messages!.isNotEmpty)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    widget.messages![_currentMessageIndex],
                    key: ValueKey<int>(_currentMessageIndex),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                )
              else if (widget.caption != null)
                Text(
                  widget.caption!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
            ],
          ),
          if (widget.images != null && widget.images!.length > 1)
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Swipe to see more',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class VideoScreen extends StatelessWidget {
  final String videoPath;

  const VideoScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController controller =
        VideoPlayerController.asset(videoPath);

    return Scaffold(
      appBar: AppBar(title: const Text('Video View')),
      body: Center(
        child: FutureBuilder(
          future: controller.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        },
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class ImageSlideshowScreen extends StatelessWidget {
  final List<String> images;

  const ImageSlideshowScreen({Key? key, required this.images})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Slideshow')),
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final isVideo = images[index].endsWith('.mp4');
          return Column(
            children: [
              Expanded(
                child: isVideo
                    ? VideoPlayerWidget(videoPath: images[index])
                    : Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Swipe left or right to navigate',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
