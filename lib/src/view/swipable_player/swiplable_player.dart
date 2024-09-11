import 'dart:async';
import 'package:flutter/material.dart';

typedef MiniPlayerBuilder = Widget Function(double height, double percentage);

class SwipablePlayer extends StatefulWidget {
  final double minHeight;
  final double maxHeight;
  final double elevation;
  final MiniPlayerBuilder builder;
  final Curve curve;
  final Color? backgroundColor;
  final Duration duration;
  final ValueNotifier<double>? valueNotifier;
  final Function? onDismissed;
  final MiniplayerController? controller;
  final Color backgroundBoxShadow;

  const SwipablePlayer({
    super.key,
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
    this.curve = Curves.easeOut,
    this.elevation = 0,
    this.backgroundColor,
    this.valueNotifier,
    this.duration = const Duration(milliseconds: 300),
    this.onDismissed,
    this.controller,
    this.backgroundBoxShadow = Colors.black45,
  });

  @override
  State<SwipablePlayer> createState() => _SwipablePlayerState();
}

class _SwipablePlayerState extends State<SwipablePlayer> with TickerProviderStateMixin {
  late ValueNotifier<double> heightNotifier;
  ValueNotifier<double> dragDownPercentage = ValueNotifier(0);
  late double _dragHeight;
  late double _startHeight;
  bool dismissed = false;
  bool animating = false;
  int updateCount = 0;
  final StreamController<double> _heightController = StreamController<double>.broadcast();
  AnimationController? _animationController;
  bool _isFullScreen = false; // Manage full-screen state internally

  @override
  void initState() {
    super.initState();
    heightNotifier = widget.valueNotifier ?? ValueNotifier(widget.minHeight);
    _resetAnimationController();
    _dragHeight = heightNotifier.value;

    if (widget.controller != null) {
      widget.controller!.addListener(controllerListener);
    }
  }

  @override
  void dispose() {
    _heightController.close();
    _animationController?.dispose();
    if (widget.controller != null) {
      widget.controller!.removeListener(controllerListener);
    }
    super.dispose();
  }

  void _resetAnimationController({Duration? duration}) {
    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: duration ?? widget.duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _resetAnimationController();
      });
    animating = false;
  }

  void _handleHeightChange({bool animation = false}) {
    if (_dragHeight >= widget.minHeight) {
      if (dragDownPercentage.value != 0) {
        dragDownPercentage.value = 0;
      }

      if (_dragHeight > widget.maxHeight) return;

      heightNotifier.value = _dragHeight;
    } else if (widget.onDismissed != null) {
      final percentageDown = ((widget.minHeight - _dragHeight) / widget.minHeight).clamp(0.0, 1.0);

      if (dragDownPercentage.value != percentageDown) {
        dragDownPercentage.value = percentageDown;
      }

      if (percentageDown >= 1 && animation && !dismissed) {
        widget.onDismissed?.call();
        setState(() => dismissed = true);
      }
    }
  }

  void _snapToPosition(PanelState snapPosition) {
    switch (snapPosition) {
      case PanelState.MAX:
        _animateToHeight(MediaQuery.of(context).size.height);
        break;
      case PanelState.MIN:
        _animateToHeight(widget.minHeight);
        break;
      case PanelState.DISMISS:
        _animateToHeight(0);
        break;
    }
  }

  void _animateToHeight(final double h, {Duration? duration}) {
    if (_animationController == null) return;
    final startHeight = _dragHeight;

    if (duration != null) {
      _resetAnimationController(duration: duration);
    }

    Animation<double> sizeAnimation = Tween(
      begin: startHeight,
      end: h,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: widget.curve),
    );

    sizeAnimation.addListener(() {
      if (sizeAnimation.value == startHeight) return;

      _dragHeight = sizeAnimation.value;

      _handleHeightChange(animation: true);
    });

    animating = true;
    _animationController!.forward(from: 0);
  }

  void controllerListener() {
    if (widget.controller == null) return;
    if (widget.controller!.value == null) return;

    switch (widget.controller!.value!.height) {
      case -1:
        _animateToHeight(widget.minHeight, duration: widget.controller!.value!.duration);
        break;
      case -2:
        _animateToHeight(MediaQuery.of(context).size.height, duration: widget.controller!.value!.duration);
        break;
      case -3:
        _animateToHeight(0, duration: widget.controller!.value!.duration);
        break;
      default:
        _animateToHeight(widget.controller!.value!.height.toDouble(), duration: widget.controller!.value!.duration);
        break;
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        _animateToHeight(MediaQuery.of(context).size.height);
      } else {
        _animateToHeight(widget.minHeight);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dismissed) {
      return Container();
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (heightNotifier.value > widget.minHeight && !_isFullScreen) {
          _snapToPosition(PanelState.MIN);
          return false;
        }
        return true;
      },
      child: ValueListenableBuilder<double>(
        valueListenable: heightNotifier,
        builder: (context, height, child) {
          var percentage = ((height - widget.minHeight)) / (widget.maxHeight - widget.minHeight);

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (percentage > 0)
                GestureDetector(
                  onTap: () => _animateToHeight(widget.minHeight),
                  child: Opacity(
                    opacity: (1 - percentage).clamp(0.0, 1.0),
                    child: Container(color: widget.backgroundColor),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: _isFullScreen
                      ? MediaQuery.of(context).size.height
                      : height, // Use height for full-screen or minimized
                  child: GestureDetector(
                    onTap: () {
                      if (_isFullScreen) {
                        _toggleFullScreen(); // Toggle back to minimized
                      } else {
                        _snapToPosition(
                          PanelState.MAX
                        );
                      }
                    },
                    onPanStart: (details) {
                      _startHeight = _dragHeight;
                      updateCount = 0;

                      if (animating) {
                        _resetAnimationController();
                      }
                    },
                    onPanUpdate: (details) {
                      if (dismissed) return;

                      _dragHeight -= details.delta.dy;
                      updateCount++;

                      _handleHeightChange();
                    },
                    onPanEnd: (details) async {
                      double speed = (_dragHeight - _startHeight) / updateCount;

                      double snapPercentage = 0.005;
                      if (speed <= 4) {
                        snapPercentage = 0.2;
                      } else if (speed <= 9) {
                        snapPercentage = 0.08;
                      } else if (speed <= 50) {
                        snapPercentage = 0.01;
                      }

                      PanelState snap = PanelState.MIN;

                      final percentageMax = ((heightNotifier.value - widget.minHeight) / (widget.maxHeight - widget.minHeight)).clamp(0.0, 1.0);

                      if (_startHeight > widget.minHeight) {
                        if (percentageMax > 1 - snapPercentage) {
                          snap = PanelState.MAX;
                        }
                      } else {
                        if (percentageMax > snapPercentage) {
                          snap = PanelState.MAX;
                        } else if (widget.onDismissed != null &&
                            ((widget.minHeight - _dragHeight) / widget.minHeight).clamp(0.0, 1.0) > snapPercentage) {
                          snap = PanelState.DISMISS;
                        }
                      }

                      _snapToPosition(snap);
                    },
                    child: ValueListenableBuilder<double>(
                      valueListenable: dragDownPercentage,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: (1 - value * 0.8).clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0.0, widget.minHeight * value * 0.5),
                            child: child,
                          ),
                        );
                      },
                      child: Material(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: widget.backgroundBoxShadow,
                                blurRadius: widget.elevation,
                                offset: const Offset(0.0, 4),
                              ),
                            ],
                            color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: widget.builder(height, percentage),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ignore: constant_identifier_names
enum PanelState {MAX, MIN, DISMISS }

class MiniplayerController extends ValueNotifier<ControllerData?> {
  MiniplayerController() : super(null);

  void animateToHeight({double? height, PanelState? state, Duration? duration}) {
    if (height == null && state == null) {
      throw ("One of height or state must be specified.");
    }

    if (height != null && state != null) {
      throw ("Specify only one of height or state.");
    }

    ControllerData? valBefore = value;

    if (state != null) {
      value = ControllerData(state.heightCode, duration);
    } else {
      if (height! < 0) return;

      value = ControllerData(height.round(), duration);
    }

    if (valBefore != value) {
      notifyListeners();
    }
  }
}

class ControllerData {
  final int height;
  final Duration? duration;

  const ControllerData(this.height, this.duration);
}

extension on PanelState {
  int get heightCode {
    switch (this) {
      case PanelState.MAX:
        return -2;
      case PanelState.MIN:
        return -1;
      case PanelState.DISMISS:
        return -3;
      default:
        return 0;
    }
  }
}
