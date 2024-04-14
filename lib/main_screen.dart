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
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(_src[_selectedVideo]));
    _controller.initialize().then((value) => setState(() {}));
    _controller.play();
  }

  bool isControllerVisie = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isControllerVisie = !isControllerVisie;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )),
                isControllerVisie
                    ? Positioned(
                      bottom:8,
                      right:0,
                      left:0,
                        child: Column(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               //rewind
                               IconButton(
                                   onPressed: () async {
                                     final position =
                                         await _controller.position;
                                     final targetPosition =
                                         position!.inMilliseconds - 1000;
                                     await _controller.seekTo(Duration(
                                         milliseconds: targetPosition));
                                   },
                                   icon: const Icon(
                                       Icons.fast_rewind_rounded)),
                               //previous
                               IconButton(
                                   onPressed: () {
                                     _selectedVideo--;
                                     _selectedVideo %= _src.length;
                                     onChangeVideo();
                                   },
                                   icon: const Icon(
                                       Icons.skip_previous_rounded)),
                               //play or pause
                               IconButton(
                                   onPressed: () async {
                                     _controller.value.isPlaying
                                         ? await _controller.pause()
                                         : await _controller.play();
                        
                                     setState(() {});
                                   },
                                   icon: Icon(_controller.value.isPlaying
                                       ? Icons.pause_circle_filled_rounded
                                       : Icons.play_circle_filled_rounded)),
                               //next
                               IconButton(
                                   onPressed: () {
                                     _selectedVideo++;
                                     _selectedVideo %= _src.length;
                                     onChangeVideo();
                                   },
                                   icon:
                                       const Icon(Icons.skip_next_rounded)),
                               //forward
                               IconButton(
                                   onPressed: () async {
                                     final position =
                                         await _controller.position;
                                     final targetPosition =
                                         position!.inMilliseconds + 1000;
                                     await _controller.seekTo(Duration(
                                         milliseconds: targetPosition));
                                   },
                                   icon: const Icon(
                                       Icons.fast_forward_rounded)),
                             ],
                           ),
                           VideoProgressIndicator(
                             _controller,
                             allowScrubbing: true,
                             colors: const VideoProgressColors(
                               playedColor: Colors.red,
                               backgroundColor: Colors.black45,
                             ),
                           )
                         ],
                                                  ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  onChangeVideo() {
    _controller.dispose();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(_src[_selectedVideo]));

    _controller.addListener(() {
      setState(() {
        if (!_controller.value.isPlaying &&
            _controller.value.isInitialized &&
            (_controller.value.duration == _controller.value.position)) {
          _controller.seekTo(Duration.zero);
        }
      });
    });
    _controller.initialize().then((value) => setState(() {
          _controller.play();
        }));
  }
}
