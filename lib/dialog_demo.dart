import 'package:flutter/material.dart';

class DialogDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DialogDemo();
}

class _DialogDemo extends State<DialogDemo> {
  _generateSimpleDialog() {
    return SimpleDialog(
      title: Text('simple dialog title'),
      children: <Widget>[
        Container(
          height: 100,
          child: Text('这里填写内容'),
        ),
        FlatButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('确认'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  _generateAlertDialog() {
    return AlertDialog(
      title: Text('这是标题'),
      content: Text('这是内容'),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('确认'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialog Demo'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('show simple dialog'),
            onPressed: () => showDialog(
                context: context, builder: (_) => _generateSimpleDialog()),
          ),
          RaisedButton(
            child: Text('show alert dialog'),
            onPressed: () => showDialog(
                context: context, builder: (_) => _generateAlertDialog()),
          ),
          RaisedButton(
              child: Text('show general dialog'),
              onPressed: () {
                //  showModalBottomSheet();
                showGeneralDialog(
                    context: context,
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return ModalPage(animation);
                    },
                    barrierDismissible: false,
                    barrierLabel: 'barrierLabel',
                    transitionDuration: Duration(milliseconds: 400),
                    transitionBuilder:
                        (___, Animation<double> animation, ____, Widget child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                            .animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.fastOutSlowIn)),
                        child: child,
                      );
                    });
              }),
        ],
      ),
    );
  }
}

class ModalPage extends StatefulWidget {
  final Animation<double> animation;
  ModalPage(this.animation);

  @override
  _ModalPageState createState() => _ModalPageState();
}

class _ModalPageState extends State<ModalPage> {
  bool completed = false;
  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener((AnimationStatus status) {
      print(status);
      if (status == AnimationStatus.completed) {
        setState(() {
          completed = true;
        });
      } else if (status == AnimationStatus.reverse) {
        setState(() {
          completed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: completed ? Color.fromARGB(50, 0, 0, 0) : Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.transparent,
                  height: screenSize.height - 400,
                ),
              ),
              Container(
                height: 400,
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 40,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0)),
                              child: Container(
                                height: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 60,
                            child: Container(
                              color: Colors.red,
                              height: 60,
                              width: 60,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 300,
                      color: Colors.white,
                      child: Center(
                        child: Container(
                          height: 56.0,
                          child: TextField(),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
