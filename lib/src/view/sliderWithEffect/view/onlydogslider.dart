import 'package:flutter/material.dart';
import 'package:rnd/src/view/sliderWithEffect/view/dog_slider.dart';

class OnlyDog extends StatefulWidget {
  const OnlyDog({super.key});

  @override
  State<OnlyDog> createState() => _OnlyDogState();
}

class _OnlyDogState extends State<OnlyDog> {
  //dogslider
  int _numTreats = 0;
  final int _maxTreats = 100;


  void _handleSliderChanged(double value) {
    setState(() {
      _numTreats = ((value * _maxTreats)).round();
    });
  }
  //dogslider

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _numTreats.toString(),
            textAlign: TextAlign.center,
            style:const TextStyle(fontSize: 48, color: Color(0xff00a6a4), fontWeight: FontWeight.w600)
          ),
          const SizedBox(height: 50,),
          Center(
            child: DogSlider(
              startValue: _numTreats / _maxTreats,
              onChanged: _handleSliderChanged,
              width: size.width,
            ),
          )
        ],
      ),
    );
  }
}