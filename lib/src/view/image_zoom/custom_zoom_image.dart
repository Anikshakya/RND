import 'package:flutter/material.dart';

class CustomZoomImage extends StatefulWidget {
  final String imageUrl;
  final double? minScale;
  final double? maxScale;
  final double? fullScreenDoubleTapZoomScale;
  final Function(ScaleStartDetails)? onStart;
  final Function(ScaleEndDetails)? onEnd;
  final Function(double)? onScaleChanged; // Callback for notifying scale changes

  const CustomZoomImage({
    super.key,
    required this.imageUrl,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.fullScreenDoubleTapZoomScale = 4.0,
    this.onStart,
    this.onEnd,
    this.onScaleChanged, // Add this
  });

  @override
  State<CustomZoomImage> createState() => _ImageZoomFullscreenState();
}

class _ImageZoomFullscreenState extends State<CustomZoomImage>
    with SingleTickerProviderStateMixin {
  final TransformationController transformationController =
      TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? animation;
  TapDownDetails? _doubleTapDownDetails;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() => transformationController.value = animation!.value);

    transformationController.addListener(_onTransformationChanged); // Listen to transformation changes
  }

  void _onTransformationChanged() {
    final double scale = transformationController.value.getMaxScaleOnAxis();
    if (widget.onScaleChanged != null) {
      widget.onScaleChanged!(scale);
    }
  }

  @override
  void dispose() {
    transformationController.removeListener(_onTransformationChanged);
    transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        transformationController: transformationController,
        minScale: widget.minScale!,
        maxScale: widget.maxScale!,
        panEnabled: true, // Enable panning
        scaleEnabled: true, // Enable pinch-to-zoom
        onInteractionStart: widget.onStart ?? (_) {},
        onInteractionEnd: widget.onEnd ?? (_) {},
        child: GestureDetector(
          onDoubleTapDown: (details) => _doubleTapDownDetails = details,
          onDoubleTap: _zoomInOut,
          child: Image.network(
            widget.imageUrl.toString(),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  void _zoomInOut() {
    final Offset tapPosition = _doubleTapDownDetails!.localPosition;
    final double zoomScale = widget.fullScreenDoubleTapZoomScale ?? 4.0;

    final double x = -tapPosition.dx * (zoomScale - 1);
    final double y = -tapPosition.dy * (zoomScale - 1);

    final Matrix4 zoomedMatrix = Matrix4.identity()
      ..translate(x, y)
      ..scale(zoomScale);

    final Matrix4 widgetMatrix = transformationController.value.isIdentity()
        ? zoomedMatrix
        : Matrix4.identity();

    animation = Matrix4Tween(
      begin: transformationController.value,
      end: widgetMatrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController),
    );

    _animationController.forward(from: 0);
  }
}
