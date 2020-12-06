import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ReelsScreen extends StatefulWidget {
  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  VideoPlayerController _controller;
  List<String> a = [];

  Future getVideos() async {
    List<String> videos = [];
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("reels")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data()["url"]);
        videos.insert(videos.length, result.data()["url"]);
      });
    });
    return videos;
  }

  @override
  void initState() {
    getVideos().then((value) {
      print(value);
      a = value;
      _controller = VideoPlayerController.network(value[0]);
      _controller.addListener(() {
        setState(() {});
      });
      _controller.setLooping(true);
      _controller.initialize().then((_) => setState(() {}));
      _controller.play();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'REELS',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: _controller == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: PageController(initialPage: 0),
                    onPageChanged: (int index) {
                      setState(() {});
                      _controller =
                          VideoPlayerController.network(a[index % a.length]);
                      _controller.addListener(() {
                        setState(() {});
                      });
                      _controller.setLooping(true);
                      _controller.initialize();
                      _controller.play();
                    },
                    itemBuilder: (context, index) {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    }),
              ));
  }
}
