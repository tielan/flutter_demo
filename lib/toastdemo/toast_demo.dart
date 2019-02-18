import 'package:flutter/material.dart';
import '../widget/toast.dart';

class ToastDemo extends StatefulWidget {
  @override
  _ToastDemoState createState() => _ToastDemoState();
}

class _ToastDemoState extends State<ToastDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toast Demo'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: InkWell(
            onTap: () {
              Toast.show(context, 'showToast');
            },
            child: Text('showToast'),
          ),
        ),
      ),
    );
  }
}
