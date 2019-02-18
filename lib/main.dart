import 'package:flutter/material.dart';
import './toastdemo/toast_demo.dart';
import './loadingdemo/loading_demo.dart';
import './dialog_demo.dart';
import './location/loc_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: ListView(
        children: <Widget>[
          buildItem(context, "1、Toast Demo", (BuildContext context) {
            return ToastDemo();
          }),
          buildItem(context, "2、Loading Demo", (BuildContext context) {
            return LoadingDemo();
          }),
          buildItem(context, "3、Dialog Demo", (BuildContext context) {
            return DialogDemo();
          }),
          buildItem(context, "4、Location Demo", (BuildContext context) {
            return LocationDemo();
          }),
          buildItem(context, "5、VideoPlay Demo", (BuildContext context) {
            return LoadingDemo();
          }),
          buildItem(context, "6、QR Demo", (BuildContext context) {
            return LoadingDemo();
          })
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, String title, WidgetBuilder builder) {
    return InkWell(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: builder));
      },
      child: Container(
        height: 44.0,
        padding: EdgeInsets.only(left: 16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(border: Border(bottom: BorderSide())),
        child: Text(title),
      ),
    );
  }
}

// void showMenu(BuildContext context) {
//   RenderBox box = context.findRenderObject();
//   double startY = box.localToGlobal(Offset(0.0, box.size.height)).dy;
//   Menu.show(context,startY, 'fdfasdsadf');
// }
