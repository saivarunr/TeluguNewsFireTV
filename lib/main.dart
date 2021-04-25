import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

import 'YoutubePlayer.dart';

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
  bool loading = false;

  int channelIndex = 0;
  List<String> channelIDs = [];
  List<String> channelNames = [];

  get isLoading =>
      loading || channelNames.length == 0 || channelIDs.length == 0;

  void initState() {
    try {
      Screen.keepOn(true);
      this.fetchChannels();
    } catch (e) {}
    super.initState();
  }

  Future<void> fetchChannels() async {
    setState(() {
      this.loading = true;
    });
    Dio dio = new Dio();
    Response response = await dio.get(
        "https://gist.githubusercontent.com/saivarunr/46acbe51527075da10c7315d0922e66d/raw/json");
    Map<String, dynamic> raw = jsonDecode(response.data);
    Map<String, String> data =
        raw.map((key, value) => MapEntry(key, value.toString()));

    setState(() {
      this.channelIDs = data.values.toList();
      this.channelNames = data.keys.toList();
      this.loading = false;
    });
  }

  @override
  void dispose() {
    this.focusNode?.dispose();
    super.dispose();
  }

  void onChange(RawKeyEvent rawKeyEvent) {
    if (rawKeyEvent.runtimeType.toString() == 'RawKeyDownEvent') {
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
    String channelID;
    if (this.channelIDs.length > 0) {
      channelID = channelIDs[channelIndex];
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RawKeyboardListener(
              onKey: this.onChange,
              focusNode: this.focusNode,
              child: YouTubePlayer(key: Key(channelID), channelID: channelID),
            ),
    );
  }
}
