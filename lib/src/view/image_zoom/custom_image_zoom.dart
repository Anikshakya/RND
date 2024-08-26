import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomZoom1 extends StatefulWidget {
  final Widget zoomWidget;
  final double? minScale;
  final double? maxScale;
  final Object heroAnimationTag;
  final double? fullScreenDoubleTapZoomScale;

  const CustomZoom1({
    super.key,
    required this.zoomWidget,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    required this.heroAnimationTag,
    this.fullScreenDoubleTapZoomScale = 4,
  });

  @override
  State<CustomZoom1> createState() => _ImageZoomFullscreenState();
}

class _ImageZoomFullscreenState extends State<CustomZoom1>
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
  }

  @override
  void dispose() {
    transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      minScale: widget.minScale!,
      maxScale: widget.maxScale!,
      panEnabled: true, // Enable panning
      scaleEnabled: true, // Enable pinch-to-zoom
      child: GestureDetector(
        onDoubleTapDown: (details) => _doubleTapDownDetails = details,
        onDoubleTap: _zoomInOut,
        child: Hero(
          tag: widget.heroAnimationTag,
          child: widget.zoomWidget,
        ),
      ),
    );
  }

  void _zoomInOut() {
    final Offset tapPosition = _doubleTapDownDetails!.localPosition;
    final double zoomScale =
        widget.fullScreenDoubleTapZoomScale ?? widget.maxScale!;

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
