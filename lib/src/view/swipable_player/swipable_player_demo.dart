import 'package:flutter/material.dart';
import 'package:rnd/src/view/swipable_player/custom_videoplayer.dart';
import 'package:rnd/src/view/swipable_player/swiplable_player.dart';

class SwipableVideoPlayerDemo extends StatefulWidget {
  const SwipableVideoPlayerDemo({super.key});

  @override
  State<SwipableVideoPlayerDemo> createState() => _SwipableVideoPlayerDemoState();
}

class _SwipableVideoPlayerDemoState extends State<SwipableVideoPlayerDemo> {
  final MiniplayerController _controller = MiniplayerController();
  bool isMinimized = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _controller.animateToHeight(height: MediaQuery.of(context).size.height);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleFullScreen() {
    setState(() {
      if (isMinimized) {
        _controller.animateToHeight(height: MediaQuery.of(context).size.height);
        isMinimized = false;
      } else {
        _controller.animateToHeight(height: 60);
        isMinimized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipable Player'),
      ),
      body: Stack(
        children: [
          // Main content of the page
          const Center(
            child: Text('Main Content Here'),
          ),
          // Mini Player
          SwipablePlayer(
            minHeight: 60,
            maxHeight: MediaQuery.of(context).size.height,
            builder: (height, percentage) {
              isMinimized = height == 60; // Update the minimized state
              return Column(
                children: [
                  // Video Player
                  Container(
                    height: height > 60
                        ? 60 + (300 * (height / MediaQuery.of(context).size.height))
                        : 60,
                    color: Colors.black,
                    child: VideoPlayerWidget(
                      isMinimized: height > 60 ? false : true,
                      canPlay: true,
                      url: "https://media.istockphoto.com/id/186900953/video/time-seconds-hand-twelve-ti.mp4?s=mp4-640x640-is&k=20&c=bFYO6aQyYPzeXy_2AdN2XVvEQn-oijK9BRcM1JqnocE=",
                    ),
                  ),
                  // Lower content with Tab Bar
                  Expanded(
                    child: DefaultTabController(
                      length: 2, // Number of tabs
                      child: Column(
                        children: [
                          // Tab Bar
                          const TabBar(
                            indicatorColor: Colors.deepPurple,
                            tabs: [
                              Tab(text: 'Tab 1'),
                              Tab(text: 'Tab 2'),
                            ],
                          ),
                          // Tab Bar View
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Content for Tab 1
                                Container(
                                  color: Colors.blueAccent,
                                  child: const Center(
                                    child: Text(
                                      'Content for Tab 1',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                // Content for Tab 2
                                Container(
                                  color: Colors.greenAccent,
                                  child: const Center(
                                    child: Text(
                                      'Content for Tab 2',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            controller: _controller,
          ),

        ],
      ),
    );
  }
}