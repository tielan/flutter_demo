import 'package:flutter/material.dart';

class QRDemo extends StatefulWidget {
  @override
  _QRDemoState createState() => _QRDemoState();
}

class _QRDemoState extends State<QRDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Demo'),
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}