import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'full_screen_video.dart';
import 'full_screen_image.dart';
import 'full_screen_image_slideshow.dart';

class PolaroidCard extends StatefulWidget {
  final String imagePath;
  final String videoPath;
  final String? caption;
  final List<String>? images; // List of images for slideshow

  const PolaroidCard({
    Key? key,
    required this.imagePath,
    required this.videoPath,
    this.caption,
    this.images,
  }) : super(key: key);

  @override
  _PolaroidCardState createState() => _PolaroidCardState();
}

class _PolaroidCardState extends State<PolaroidCard> {
  late PageController _pageController;
  late VideoPlayerController _videoController;
  int _currentPageIndex = 0;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

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

    // Start slideshow if images are present
    if (widget.images != null && widget.images!.isNotEmpty) {
      Future.delayed(const Duration(seconds: 2), _autoSlideImages);
    }
  }

  void _autoSlideImages() {
    if (widget.images != null && widget.images!.isNotEmpty) {
      setState(() {
        _currentPageIndex = (_currentPageIndex + 1) % widget.images!.length;
        _pageController.animateToPage(
          _currentPageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
      Future.delayed(const Duration(seconds: 2), _autoSlideImages);
    }
  }

  @override
  void dispose() {
    if (widget.videoPath.isNotEmpty) {
      _videoController.dispose();
    }
    _pageController.dispose();
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
    } else if (widget.images != null && widget.images!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FullScreenImageSlideshow(images: widget.images!),
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
            height: 120,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.images != null && widget.images!.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: widget.images!.length,
                      itemBuilder: (context, index) {
                        final imagePath = widget.images![index];
                        final isVideo = imagePath.endsWith('.mp4');
                        if (isVideo && _isVideoInitialized) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                              const Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 40,
                              ),
                            ],
                          );
                        }
                        return Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : widget.videoPath.isNotEmpty
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _isVideoInitialized
                                  ? _videoController.value.aspectRatio
                                  : 16 / 9,
                              child: _isVideoInitialized
                                  ? VideoPlayer(_videoController)
                                  : const CircularProgressIndicator(),
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
