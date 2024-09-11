import 'package:flutter/material.dart';
import 'package:rnd/src/view/image_zoom/custom_image_slider_zoom.dart';

class ImageZoom extends StatelessWidget {
  const ImageZoom({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: 
      ImageSliderWithZoom(
        imageUrls: [
          'https://zoaroundtheworld.files.wordpress.com/2018/11/japan-feature-image.png',
          'https://zoaroundtheworld.files.wordpress.com/2018/11/japan-feature-image.png',
          'https://zoaroundtheworld.files.wordpress.com/2018/11/japan-feature-image.png'
        ],
      )
    );
  }
}