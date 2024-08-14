import 'package:flutter/material.dart';

class BouncingWidget extends StatefulWidget {
  final bool isVisible;
  final Widget child;
  final double maxBounce;

  const BouncingWidget({super.key, this.isVisible = false, required this.child, this.maxBounce = 20});

  @override
  State<BouncingWidget> createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget> {
  double _offsetY = 0;
  final Duration _bounceDuration = const Duration(milliseconds: 700);
  Curve _bounceCurve = Curves.easeOut;

  @override
  void initState() {
    _bounceIcon(true);
    super.initState();
  }

  void _bounceIcon(bool up) async {
    _bounceCurve = up ? Curves.easeOut : Curves.easeIn;
    setState(() => _offsetY = up ? 0 : 20);
    await Future.delayed(_bounceDuration);
    if (mounted) {
      _bounceIcon(!up);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isVisible ? 1 : 0,
      duration: const Duration(milliseconds: 350),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: _offsetY),
        curve: _bounceCurve,
        duration: _bounceDuration,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value, 0),
            child: widget.child,
          );
        },
      ),
    );
  }
}