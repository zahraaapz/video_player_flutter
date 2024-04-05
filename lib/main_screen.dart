import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

List<String> _src = [
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
];
int _selectedVideo = 0;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(_src[_selectedVideo]));
    _videoPlayerController.initialize().then((value) => setState(() {}));
    _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              )),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 50,
                  color: Colors.amber,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                final position =
                                    await _videoPlayerController.position;
                                final targetPosition =
                                    position!.inMilliseconds - 1000;
                                await _videoPlayerController.seekTo(
                                    Duration(milliseconds: targetPosition));
                              },
                              icon: const Icon(Icons.fast_rewind_rounded)),
                          IconButton(
                              onPressed: () async {
                                final position =
                                    await _videoPlayerController.position;
                                final targetPosition =
                                    position!.inMilliseconds + 1000;
                                await _videoPlayerController.seekTo(
                                    Duration(milliseconds: targetPosition));
                              },
                              icon: const Icon(Icons.fast_forward_rounded)),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
