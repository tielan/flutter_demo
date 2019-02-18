import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  List images = [
    Icon(
      Icons.accessible,
      size: 100.0,
    ),
    Icon(
      Icons.accessibility,
      size: 100.0,
    ),
    Icon(
      Icons.accessible,
      size: 100.0,
    ),
    Icon(
      Icons.accessibility,
      size: 100.0,
    ),
  ];
  AnimationController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(seconds: 10), vsync: this);
    Animation<int> animation =
        new IntTween(begin: 4, end: 44).animate(controller);
    animation.addListener(() {
      setState(() {
        currentIndex = animation.value % 4;
      });
    });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: images[currentIndex],
    );
  }
}
