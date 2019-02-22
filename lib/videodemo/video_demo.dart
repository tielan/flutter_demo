import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player/youtube_player.dart';

class VideoPlayDemo extends StatefulWidget {
  @override
  _VideoPlayDemoState createState() => _VideoPlayDemoState();
}

class _VideoPlayDemoState extends State<VideoPlayDemo> {
  VideoPlayerController _videoController;
  String videoUrl;
  bool startFullScreen;
  @override
  void initState() {
    super.initState();
    startFullScreen = false;
    videoUrl =
        "https://ninghao.net/system/dynamics/video/webapp-season1-01-01-01-workflow-733751090.mp4";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              YoutubePlayer(
                context: context,
                source: videoUrl,
                startFullScreen: startFullScreen,
                callbackController: (controller) {
                  _videoController = controller;
                },
              ),
              Positioned(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      startFullScreen = false;
                    });
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 100),
          Container(
            child: InkWell(
              onTap: () {
                setState(() {
                  videoUrl =
                      'https://ninghao.net/system/dynamics/video/webapp-season1-04-01-01-navbar-styles-611106901.mp4';
                });
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('切换视频'),
              ),
            ),
          ),
          Container(
            child: InkWell(
              onTap: () {
                setState(() {
                  videoUrl =
                      'https://ninghao.net/system/dynamics/video/webapp-season1-04-01-04-navbar-header-227664732.mp4';
                });
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('切换视频2'),
              ),
            ),
          ),
          Container(
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('退出全屏'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
