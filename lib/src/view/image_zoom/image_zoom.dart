import 'package:flutter/material.dart';
import 'package:rnd/src/view/image_zoom/custom_image_zoom.dart';

class ImageZoom extends StatelessWidget {
  const ImageZoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomZoom1(
        heroAnimationTag: "Hero",
        zoomWidget:  Image.network(
          "https://zoaroundtheworld.files.wordpress.com/2018/11/japan-feature-image.png",
          height: MediaQuery.of(context).size.height,
        )
      )
    );
  }
}