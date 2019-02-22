import 'package:flutter/material.dart';
import '../picker/picker.dart';

class LocationDemo extends StatefulWidget {
  @override
  _LocationDemoState createState() => _LocationDemoState();
}

class _LocationDemoState extends State<LocationDemo> {
  String province = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Demo'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Pick location',
                        style: TextStyle(fontSize: 24.0, height: 2.0),
                      ),
                      Text(
                        '$province ',
                        style: TextStyle(fontSize: 22.0),
                      )
                    ],
                  ),
                  onPressed: () {
                    Picker.showLocationPicker(
                      context,
                      initialNames: province,
                      onConfirm: (p, c) {
                        print('$p $c');
                        setState(() {
                          province = p;
                        });
                      },
                    );
                  }),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Pick location',
                        style: TextStyle(fontSize: 24.0, height: 2.0),
                      ),
                      Text(
                        '$province ',
                        style: TextStyle(fontSize: 22.0),
                      )
                    ],
                  ),
                  onPressed: () {
                    Picker.showSelectPicker(
                      context,
                      listData: ['男', '女', '保密'],
                      onConfirm: (p, c) {
                        print('$p $c');
                      },
                    );
                  }),
            ),
            FlatButton(
                onPressed: () {
                  Picker.showDatePicker(context, maxTime: DateTime.now(),
                      onConfirm: (date) {
                    print('confirm $date');
                  });
                },
                child: Text(
                  'show date picker(custom theme &date time range)',
                  style: TextStyle(color: Colors.blue),
                )),
          ],
        ),
      ),
    );
  }
}
