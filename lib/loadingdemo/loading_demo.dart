import 'package:flutter/material.dart';
import '../widget/loading.dart';

class LoadingDemo extends StatefulWidget {
  @override
  _LoadingDemoState createState() => _LoadingDemoState();
}

class _LoadingDemoState extends State<LoadingDemo> {
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading Demo'),
        actions: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                showLoading = true;
              });
            },
            child: Text('show Loding'),
          )
        ],
      ),
      body:Container(
        child:  LoadingView(),
      ),
    );
  }
}
