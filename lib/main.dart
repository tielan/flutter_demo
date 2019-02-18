import 'package:flutter/material.dart';
import 'loading.dart';
import 'hud/hud.dart';
import 'hud/menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  GlobalKey menuKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: Center(
        child: InkWell(
          key: menuKey,
          onTap: () {
            showMenu(menuKey.currentContext);
          },
          child: Text('操作失败操作失败操作失败操作失败操作失败操作失败'),
        ),
      ),
    );
  }
}

void showMenu(BuildContext context) {
  RenderBox box = context.findRenderObject();
  double startY = box.localToGlobal(Offset(0.0, box.size.height)).dy;
  Menu.show(context,startY, 'fdfasdsadf');
}
