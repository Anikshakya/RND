// Add flare_flutter to pubspec for flare animation
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:rnd/src/view/sliderWithEffect/functions/dog_flare_collection.dart';
import 'package:rnd/src/view/sliderWithEffect/functions/env.dart';
import 'package:rnd/src/view/sliderWithEffect/functions/moving_character.dart';

import '../functions/dog_slider_bg_painter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../functions/bouncing_icon.dart';

class DogSlider extends StatefulWidget {
  final double arcRadius;
  final ValueChanged<double>? onChanged;
  final double width;
  final double hzPadding;
  final double startValue;

  const DogSlider(
      {super.key,
      required this.onChanged,
      this.width = 100,
      this.arcRadius = 15,
      this.hzPadding = 40,
      this.startValue = .5});

  @override
  // ignore: library_private_types_in_public_api
  _DogSliderState createState() => _DogSliderState();
}

class _DogSliderState extends State<DogSlider> with TickerProviderStateMixin {
  static const String _pkg = "dog_slider";
  static String? get pkg => Env.getPackage(_pkg);
  static const double _offscreenX = -50;
  static const double _bottomPadding = 15;

  late AnimationController _ballAnim;
  late Ticker _dogTicker;
  late MovingCharacterPhysics2d _dogPhysics;
  late DogFlareControls _dogController;

  double _slidePosX = 230;
  double _sliderValue = 0;
  final double _dogWidth = 100;

  @override
  void initState() {
    //Move slider to start pos
    _slidePosX = widget.hzPadding + widget.startValue * (widget.width - widget.hzPadding);
    _sliderValue = widget.startValue;

    //animationController to handle our ball
    _ballAnim = AnimationController(vsync: this)..addListener(() => setState(() {}));
    //Dog controller to handle animations
    _dogController = DogFlareControls();
    //Character physics for dog
    _dogPhysics = MovingCharacterPhysics2d(
      //Start dog offscreen
      startX: _offscreenX,
      //If value is 0, keep dog offscreen, otherwise, set target to the current slider pos
      targetX: _sliderValue == 0 ? _offscreenX : _slidePosX,
      //Play walk anim when moving
      onMoveStarted: () => _dogController.play("walk"),
      //play sit animation when we reach our destination
      onDestinationReached: () => _dogController.play("sit-front"),
    );
    //Use Ticker to redraw view, and update dog physics
    _dogTicker = Ticker((elapsed) {
      setState(() => _dogPhysics.update(elapsed));
    });
    _startDogTicker();
    super.initState();
  }

  @override
  void dispose() {
    _dogTicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = max(widget.width, 100.0);
    double height = 100;
    double ballSize = widget.arcRadius * 1.35;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (_) => _handlePanUpdate(_.globalPosition.dx),
      onPanDown: (_) => handlePanDown(),
      onPanCancel: () => handlePanEnd(),
      onPanEnd: (_) => handlePanEnd(),
      child: SizedBox(
        width: width,
        height: height,
        //color: Colors.red.shade50,
        child: Stack(
          children: <Widget>[
            //The background lines/floor
            Positioned(                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
              left: 0,
              child: GestureDetector(
                onTap: (){
                  HapticFeedback.heavyImpact();
                },
                child: CustomPaint(
                  foregroundPainter: DogSliderBgPainter(
                    xPos: _slidePosX,
                    arcRadius: widget.arcRadius,
                    arcScaleY: max(0, 1 - _ballAnim.value * 2),
                    bottomPadding: _bottomPadding,
                  ),
                  size: Size(width, height),
                ),
              ),
            ),

            //Running dog
            _buildFlareActor(),

            //The ball
            Positioned(
              bottom: _bottomPadding + 4 + _ballAnim.value * 30,
              left: _slidePosX - ballSize * .5,
              width: ballSize,
              height: ballSize,
              child: _buildBallAndArrowStack(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBallAndArrowStack() {
    return Stack(
      children: <Widget>[
        Image.asset("lib/src/view/sliderWithEffect/images/ball.png", package: pkg),
        Transform.translate(
          offset: const Offset(26, -2),
          child: BouncingWidget(
            isVisible: _sliderValue == 0 && _ballAnim.value < .2,
            child: const Icon(Icons.arrow_forward_ios, size: 22, color: Color(0xff174d4c)),
          ),
        ),
      ],
    );
  }

  Widget _buildFlareActor() {
    //Set the position of the dog, according to the character physics
    var dogPosition = _dogPhysics.position;
    var walkingDog = FlareActor(
      "lib/src/view/sliderWithEffect/images/DogAnimation.flr",
      controller: _dogController,
      fit: BoxFit.fitWidth,
      alignment: Alignment.bottomCenter,
      snapToEnd: true,
    );
    return Positioned(
      bottom: _bottomPadding + 6,
      left: dogPosition,
      child: Container(
        alignment: Alignment.center,
        //color: Colors.blue,
        transform: Matrix4.diagonal3Values(_dogPhysics.flipView ? -1 : 1, 1, 1),
        width: _dogWidth,
        height: _dogWidth,
        child: Transform(
          transform: Matrix4.translationValues(-_dogWidth * .5, 0, 0),
          child: walkingDog,
        ),
      ),
    );
  }

  void _handlePanUpdate(double xPos) {
    //Ff ticker is not going, fire it up
    if (!_dogTicker.isTicking) {
      _dogTicker.start();
    }
    //calculate current xPos and dispatch change events
    setState(() {
      //Inject targetX into dogPhysics
      _slidePosX = xPos.clamp(widget.hzPadding, widget.width - widget.hzPadding);
      _sliderValue = (_slidePosX - widget.hzPadding) / (widget.width - widget.hzPadding * 2);
      widget.onChanged?.call(_sliderValue);
      _dogPhysics.targetX = _sliderValue == 0 ? _offscreenX : _slidePosX;
    });
  }

  void handlePanDown() {
    _ballAnim.animateTo(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutBack);
  }

  void handlePanEnd() {
    _ballAnim.animateTo(0, duration: const Duration(milliseconds: 600), curve: const ElasticOutCurve(.3));
  }

  void _startDogTicker() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _dogTicker.start();
  }
}