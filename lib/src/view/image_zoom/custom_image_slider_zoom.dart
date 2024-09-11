import 'package:flutter/material.dart';
import 'package:rnd/src/view/image_zoom/custom_zoom_image.dart';

class ImageSliderWithZoom extends StatefulWidget {
  final List<String> imageUrls;
  final double? minScale;
  final double? maxScale;
  final double? fullScreenDoubleTapZoomScale;

  const ImageSliderWithZoom({
    super.key,
    required this.imageUrls,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.fullScreenDoubleTapZoomScale = 4.0,
  });

  @override
  State<ImageSliderWithZoom> createState() => _ImageZoomFullscreenState();
}

class _ImageZoomFullscreenState extends State<ImageSliderWithZoom> {
  final List<int> events = [];
  bool _canScroll = true;
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // or Colors.white depending on your background preference
      body: Stack(
        children: [
          Listener(
            onPointerDown: (event) {
              events.add(event.pointer);
            },
            onPointerUp: (event) {
              events.clear();
              setState(() {
                _canScroll = true;
              });
            },
            onPointerMove: (event) {
              if (events.length == 2) {
                setState(() {
                  _canScroll = false;
                });
              }
            },
            child: PageView.builder(
              controller: _pageController,
              physics: _canScroll
                  ? const ScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _currentPage = index;
                  });
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return CustomZoomImage(
                  imageUrl: widget.imageUrls[index],
                  minScale: widget.minScale!,
                  maxScale: widget.maxScale!,
                  onScaleChanged: (scale) {
                    setState(() {
                      _canScroll = scale == 1.0; // Allow scroll only if image is at original scale
                    });
                  },
                );
              },
            ),
          ),
          Positioned(
            top: 40, // Adjust based on status bar height
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white, // Ensures visibility on black background
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _buildPageIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.imageUrls.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 12.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}