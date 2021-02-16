import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

class YouTubePlayer extends StatefulWidget {
  final String channelID;

  const YouTubePlayer({Key key, this.channelID}) : super(key: key);

  @override
  _YouTubePlayerState createState() => _YouTubePlayerState();
}

class _YouTubePlayerState extends State<YouTubePlayer>
    implements YouTubePlayerListener {
  double _volume = 50;
  double _videoDuration = 0.0;
  double _currentVideoSecond = 0.0;
  String _playerState = "";
  FlutterYoutubeViewController _controller;
  YoutubeScaleMode _mode = YoutubeScaleMode.none;
  PlaybackRate _playbackRate = PlaybackRate.RATE_1;
  bool _isMuted = false;
  List<String> channels = [
    'Q6QR4979KIQ',
    'Sg3EfBJIqsk',
    'bl9VaUaI0r0',
    'qc5nFUYRehA',
    'IHuHxUo4Yps'
  ];
  int currentIndex = 0;

  @override
  void onCurrentSecond(double second) {
    // print("onCurrentSecond second = $second");
    _currentVideoSecond = second;
  }

  @override
  void onError(String error) {
    print("onError error = $error");
  }

  @override
  void onReady() {
    print("onReady");
  }

  @override
  void onStateChange(String state) {
    print("onStateChange state = $state");
    setState(() {
      _playerState = state;
    });
  }

  @override
  void onVideoDuration(double duration) {
    print("onVideoDuration duration = $duration");
  }

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
    this._controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterYoutubeView(
      scaleMode: _mode,
      onViewCreated: _onYoutubeCreated,
      listener: this,
      params: YoutubeParam(
        videoId: this.widget.channelID,
        showUI: false,
        startSeconds: 0.0,
        autoPlay: true,
      ),
    ));
  }
}
