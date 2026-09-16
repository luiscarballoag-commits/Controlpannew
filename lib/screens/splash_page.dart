import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final VideoPlayerController _videoController;
  bool _isInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(
      'assets/videos/controlpan_intro.mp4',
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    await _videoController.initialize();

    if (!mounted) return;

    setState(() {
      _isInitialized = true;
    });

    _videoController.addListener(_videoListener);
    await _videoController.play();
  }

  void _videoListener() {
    if (!_videoController.value.isInitialized ||
        _hasNavigated ||
        !_videoController.value.isCompleted) {
      return;
    }

    _hasNavigated = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const HomePage(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
