// Add video_player package in PubSpec
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.url,
    this.content,
    this.currentIndex,
    this.index,
    this.canPlay,
    required this.isMinimized,
  });

  final String url;
  final Widget? content;
  final int? currentIndex;
  final int? index;
  final bool? canPlay;
  final bool isMinimized; // Check if player is minimized

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> with SingleTickerProviderStateMixin {
  late VideoPlayerController videoPlayerController;
  bool disposed = false;
  bool isPlaying = false;
  bool isControlsVisible = true;
  Timer? _hideControlsTimer; // Handle timer properly
  final Completer<void> completer = Completer();

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _hideControlsTimer?.cancel(); // Cancel timer if exists
    disposed = true;
    super.dispose();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.canPlay != widget.canPlay) {
      controlVideoPlayPause();
    }
  }

  void initializeVideo() {
    // ignore: deprecated_member_use
    videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            completer.complete();
            isPlaying = widget.canPlay ?? false;
            controlVideoPlayPause();
          });
        }
      });
  }

  void controlVideoPlayPause() {
    if (mounted) {
      videoPlayerController.setLooping(true);
      if (widget.canPlay == true && widget.currentIndex == widget.index) {
        disposed = false;
        videoPlayerController.play();
        setState(() {
          isPlaying = true;
        });
      } else {
        disposed = false;
        videoPlayerController.pause();
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        videoPlayerController.pause();
      } else {
        videoPlayerController.play();
      }
      isPlaying = !isPlaying;
      _startHideControlsTimer();
    });
  }

  void _toggleFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(controller: videoPlayerController),
      ),
    );
    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel(); // Cancel any existing timer
    setState(() {
      isControlsVisible = true;
    });
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isControlsVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if(isControlsVisible == true){
            isControlsVisible = false;
            _hideControlsTimer?.cancel(); // Cancel any existing timer
          } else {
            isControlsVisible = true;
            _startHideControlsTimer();
          }
        });
      },
      child: FutureBuilder(
        future: completer.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: videoPlayerController.value.size.width,
                    height: videoPlayerController.value.size.height,
                    child: VideoPlayer(videoPlayerController),
                  ),
                ),
                if (isControlsVisible && !widget.isMinimized)
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 50.0,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                if (isControlsVisible && !widget.isMinimized)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: _toggleFullScreen,
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(
                    videoPlayerController,
                    allowScrubbing: true,
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;
  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    },
                  ),
                  Text(
                    '${_formatDuration(controller.value.position)} / ${_formatDuration(controller.value.duration)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
