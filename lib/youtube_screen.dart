import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeScreen extends StatefulWidget {
  const YoutubeScreen({super.key});

  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  late YoutubePlayerController _controller;
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isMobileData = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'S0Q4gqBUs7c',
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    _subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      setState(() {
        _isMobileData = result.first == ConnectivityResult.mobile;
      });
    });

    Connectivity().checkConnectivity().then((List<ConnectivityResult> result) {
      setState(() {
        _isMobileData = result.first == ConnectivityResult.mobile;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Video")),
      body:
          _isMobileData
              ? YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
              )
              : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'The video will play only if you are connected on mobile data. '
                    'Please switch to mobile data to watch the video.',
                  ),
                ),
              ),
    );
  }
}
