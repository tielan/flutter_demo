import 'package:flutter/material.dart';

enum HUDDialogModel {
  // the menu will hide
  Center,

  // the menu will active
  Bottom,

  // user has click menu item
  Top,

  Full,
}

class HUDDialog {
  static Offset getLocationByKey(GlobalKey anchorKey) {
    RenderBox renderBox = anchorKey.currentContext.findRenderObject();
    return renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void show(
      {@required BuildContext context,
      @required Widget child,
      HUDDialogModel model = HUDDialogModel.Bottom}) {
    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          if (model == HUDDialogModel.Bottom) {
            return ModalPage(animation: animation, child: child, model: model);
          } else {
            return ModalPage(
              child: child,
              model: model,
            );
          }
        },
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder:
            (___, Animation<double> animation, ____, Widget child) {
          if (model == HUDDialogModel.Bottom) {
            return SlideTransition(
              position:
                  Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                      .animate(CurvedAnimation(
                          parent: animation, curve: Curves.fastOutSlowIn)),
              child: child,
            );
          } else {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animation, curve: Curves.fastOutSlowIn)),
              child: child,
            );
          }
        });
  }

  static void showAttachToKey(
      {@required BuildContext context,
      @required Widget child,
      @required GlobalKey anchorKey}) {
    Offset offset = HUDDialog.getLocationByKey(anchorKey);
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  HUDDialog.dismiss(context);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: offset.dy,
                  bottom: 0,
                  child: Column(children: <Widget>[
                    child,
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HUDDialog.dismiss(context);
                        },
                        child: Container(
                          color: Color.fromARGB(153, 0, 0, 0),
                        ),
                      ),
                    )
                  ]))
            ],
          ),
        );
      },
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 400),
    );
  }
}

class ModalPage extends StatefulWidget {
  final Animation<double> animation;
  final Widget child;
  final HUDDialogModel model;
  ModalPage(
      {this.animation,
      @required this.child,
      this.model = HUDDialogModel.Bottom});
  @override
  _ModalPageState createState() => _ModalPageState();
}

class _ModalPageState extends State<ModalPage> {
  bool completed = false;
  @override
  void initState() {
    super.initState();
    widget.animation?.addStatusListener((AnimationStatus status) {
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
    Widget content;
    if (widget.model == HUDDialogModel.Bottom) {
      content = Container(
        color: completed ? Color.fromARGB(153, 0, 0, 0) : Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                  )),
            ),
            widget.child
          ],
        ),
      );
    } else if (widget.model == HUDDialogModel.Full) {
      content = widget.child;
    } else {
      content = Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              HUDDialog.dismiss(context);
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          widget.child
        ],
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: content,
    );
  }
}
