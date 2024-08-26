import 'package:flutter/material.dart';
import 'package:rnd/src/view/zoom_image/zoom_overlay_widget.dart';
import 'package:rnd/src/widgets/network_image_widgetd.dart';

class ZoomImage extends StatefulWidget {
  const ZoomImage({super.key});

  @override
  State<ZoomImage> createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  final events = [];
  bool canScroll = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Listener(
        onPointerDown: (event) {
          events.add(event.pointer);
        },
        onPointerUp: (event) {
          events.clear();
          setState(() {
            canScroll = true;
          });
        },
        onPointerMove: (event) {
          if (events.length == 2) {
            setState(() {
              canScroll = false;
            });
          }
        },
        child: ListView.separated(
          physics: canScroll
              ? const ScrollPhysics()
              : const NeverScrollableScrollPhysics(),
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
                child: const BaseImageNetworkWidget(
                  imagePath: 'https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg'
                )
              ),
            );
          },
        ),
      ),
    );
  }
}