import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

import 'YoutubePlayer.dart';
import 'Channels.dart' as channel_data;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telugu News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  FocusNode focusNode = new FocusNode();

  int channelIndex = 0;
  List<String> channelIDs = channel_data.channels.values.toList();
  List<String> channelNames = channel_data.channels.keys.toList();

  @override
  void initState() {
    try {
      Screen.keepOn(true);
    } catch (e) {}
    super.initState();
  }

  @override
  void dispose() {
    this.focusNode?.dispose();
    super.dispose();
  }

  void onChange(RawKeyEvent rawKeyEvent) {
    if (rawKeyEvent.logicalKey.keyId == LogicalKeyboardKey.arrowUp.keyId ||
        rawKeyEvent.logicalKey.keyId == LogicalKeyboardKey.arrowLeft.keyId) {
      this.nextChannel();
      return;
    }
    if (rawKeyEvent.logicalKey.keyId == LogicalKeyboardKey.arrowRight.keyId ||
        rawKeyEvent.logicalKey.keyId == LogicalKeyboardKey.arrowDown.keyId) {
      this.previousChannel();
      return;
    }
  }

  void nextChannel() {
    int currentIndex = this.channelIndex;
    currentIndex = currentIndex + 1;
    currentIndex = currentIndex % this.channelIDs.length;
    setState(() {
      this.channelIndex = currentIndex;
    });
  }

  void previousChannel() {
    int currentIndex = this.channelIndex;
    currentIndex = currentIndex - 1;
    currentIndex = currentIndex % this.channelIDs.length;
    setState(() {
      this.channelIndex = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    String channelID = channelIDs[channelIndex];
    return Scaffold(
      body: RawKeyboardListener(
        onKey: this.onChange,
        focusNode: this.focusNode,
        child: YouTubePlayer(key: Key(channelID), channelID: channelID),
      ),
    );
  }
}
