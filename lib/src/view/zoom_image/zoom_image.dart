import 'package:flutter/material.dart';
import 'package:rnd/src/view/zoom_image/zoom_overlay_widget.dart';

class ZoomImage extends StatelessWidget {
  const ZoomImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10,),
        itemCount: 10,
        padding: const EdgeInsets.only(top: 10.0),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ZoomOverlay(
              modalBarrierColor: const Color.fromARGB(15, 0, 0, 0), // optional
              minScale: 0.5, // optional
              maxScale: 3.0, // optional
              twoTouchOnly: true,
              animationDuration: const Duration(milliseconds: 300),
              animationCurve: Curves.fastOutSlowIn,
              onScaleStart: () {
                debugPrint('zooming!');
              }, // optional
              onScaleStop: () {
                debugPrint('zooming ended!');
              }, // optional
              child: Image.network(
                'https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg'
              )
            ),
          );
        },
      ),
    );
  }
}