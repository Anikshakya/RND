import 'package:rnd/src/view/sliderWithEffect/functions/env.dart';

import 'dog_slider.dart';
import 'package:flutter/material.dart';


class DogSliderDemo extends StatefulWidget {
  const DogSliderDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DogSliderDemoState createState() => _DogSliderDemoState();
}

class _DogSliderDemoState extends State<DogSliderDemo> {
  static const darkGreen = Color(0xff174d4c);

  static const String _pkg = "dog_slider";
  static String? get pkg => Env.getPackage(_pkg);

  TextStyle baseStyle = TextStyle(fontFamily: "Quicksand", package: pkg);

  int _numTreats = 0;
  final int _maxTreats = 10;
  final double _maxContentWidth = 500;

  void _handleSliderChanged(double value) {
    setState(() {
      _numTreats = ((value * _maxTreats)).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildTopNav(),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _buildBackground(40),
                  _buildTopContent(),
                  Center(
                    child: DogSlider(
                      startValue: _numTreats / _maxTreats,
                      onChanged: _handleSliderChanged,
                      width: size.width,
                    ),
                  ),
                  _buildBottomContent(),
                ],
              ),
            ),
            _buildBottomMenu(),
          ],
        ),
      ),
    );
  }

  Align _buildBottomContent() {
    double contentFontSize = 13;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: _maxContentWidth,
        padding: const EdgeInsets.only(left: 26, right: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("PRODUCT DETAIL", style: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text("Fetch Tennis Ball - 2.0 inch",
                style: baseStyle.copyWith(fontSize: contentFontSize, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Colour: Green", style: baseStyle.copyWith(fontSize: contentFontSize)),
            Text("Size: 2.5 inch", style: baseStyle.copyWith(fontSize: contentFontSize)),
            const SizedBox(height: 8),
            Text(
                "For stimulating playtime that encourages pets to leap and chase. Made from a high-quality natural latex and designed for the game of fetch. ",
                style: baseStyle.copyWith(fontSize: contentFontSize)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Container _buildTopContent() {
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: <Widget>[
          Text("How many fetch balls\ndoes your dog want?",
              textAlign: TextAlign.center, style: baseStyle.copyWith(fontSize: 26, fontWeight: FontWeight.w300)),
          const SizedBox(
            height: 24,
          ),
          Text(_numTreats.toString(),
              textAlign: TextAlign.center,
              style: baseStyle.copyWith(fontSize: 48, color: const Color(0xff00a6a4), fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  Container _buildBottomMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 20)]),
      child: Center(
        child: SizedBox(
          width: _maxContentWidth,
          child: Row(
            children: <Widget>[
              Text("TOTAL", style: baseStyle.copyWith(fontSize: 16)),
              const SizedBox(
                width: 6,
              ),
              Text("\$${_numTreats * 6} CAD", style: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
              const Expanded(
                child: SizedBox(),
              ),
              _buildAddToCartBtn()
            ],
          ),
        ),
      ),
    );
  }

  TextButton _buildAddToCartBtn() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xff2cb5b5),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text("ADD TO CART", style: baseStyle.copyWith(fontSize: 16, color: Colors.white)),
      onPressed: () {},
    );
  }

  Widget _buildTopNav() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.keyboard_backspace,
                color: darkGreen,
              ),
              iconSize: 32,
              onPressed: () {}),
          Expanded(
            child: Image.asset("lib/src/view/sliderWithEffect/images/logo.png", fit: BoxFit.fitHeight, height: 26, package: pkg),
          ),
          IconButton(
              icon: const Icon(
                Icons.shopping_basket,
                color: darkGreen,
              ),
              iconSize: 32,
              onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildBackground(double topPadding) {
    double topFraction = .5;
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Stack(
        children: <Widget>[
          FractionallySizedBox(
            heightFactor: topFraction,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("lib/src/view/sliderWithEffect/images/background.png", height: 150, fit: BoxFit.fitHeight, package: pkg),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 1 - topFraction,
              child: Align(
                alignment: const Alignment(0, -.8),
                child: Image.asset("lib/src/view/sliderWithEffect/images/ground.png", fit: BoxFit.fitHeight, height: 80, package: pkg),
              ),
            ),
          )
        ],
      ),
    );
  }
}