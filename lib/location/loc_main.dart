import 'package:flutter/material.dart';
import 'flutter_location_picker.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import './location.dart';

class LocationDemo extends StatefulWidget {
  @override
  _LocationDemoState createState() => _LocationDemoState();
}

class _LocationDemoState extends State<LocationDemo> {
  String province = '湖南省';
  String city = '上海';
  String town = '上海';
  @override
  void initState() {
    super.initState();
    rootBundle.loadString("data/region.json").then((String value) {
      Locations.setLocations(json.decode(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Demo'),
      ),
      body: Container(
        child: Container(
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
                    '$province $city ${town ?? ''}',
                    style: TextStyle(fontSize: 22.0),
                  )
                ],
              ),
              onPressed: () {
                LocationPicker.showPicker(
                  context,
                  showTitleActions: true,
                  initialProvince: province,
                  initialCity: city,
                  initialTown: town,
                  onChanged: (p, c, t) {
                    print('$p $c $t');
                  },
                  onConfirm: (p, c, t) {
                    print('$p $c $t');
                    setState(() {
                      province = p;
                      city = c;
                      town = t;
                    });
                  },
                );
              }),
        ),
      ),
    );
  }
}
