import 'package:flutter/material.dart';

class AnimatedSlideToRight extends StatefulWidget {
  final Widget child;
  final bool isOpen;

  const AnimatedSlideToRight({super.key, required this.child, required this.isOpen});

  @override
  State<AnimatedSlideToRight> createState() => _AnimatedSlideToRightState();
}

class _AnimatedSlideToRightState extends State<AnimatedSlideToRight> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1700));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen) _controller.forward(from: 0);
    return SlideTransition(
      position: Tween(begin: const Offset(-2, 0), end: const Offset(1, 0)).animate(
        CurvedAnimation(curve: Curves.easeOutQuad, parent: _controller),
      ),
      child: widget.child,
    );
  }
}
