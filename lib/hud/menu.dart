import 'package:flutter/material.dart';

class Menu {
  static ToastView preToast;

  static show(BuildContext context, double startY, String msg) {
    preToast?.dismiss();
    preToast = null;

    var overlayState = Overlay.of(context);
    var controllerShowOffset = new AnimationController(
        vsync: overlayState, duration: Duration(milliseconds: 350));
    var controllerCurvedShowOffset =
        new CurvedAnimation(parent: controllerShowOffset, curve: Curves.easeIn);
    var offsetAnim =
        new Tween(begin: -300.0, end: 0.0).animate(controllerCurvedShowOffset);

    OverlayEntry overlayEntry;
    overlayEntry = new OverlayEntry(builder: (context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return IgnorePointer(
              ignoring: false,
              child: Container(
                  color: Colors.white.withOpacity(0),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          color: Colors.white.withOpacity(0),
                          height: startY,
                          width: 600,
                        ),
                        onTap: () {
                          print('ok');
                          preToast?.dismiss();
                        },
                      ),
                      Positioned(
                        top: startY,
                        child: Container(
                            child: ToastWidget(
                          offsetAnim: offsetAnim,
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.red,
                          ),
                        )),
                      ),
                    ],
                  )));
        },
      );
    });
    var toastView = ToastView();
    toastView.overlayEntry = overlayEntry;
    toastView.controllerShowOffset = controllerShowOffset;
    toastView.overlayState = overlayState;
    toastView._show();
    preToast = toastView;
  }
}

class ToastView {
  OverlayEntry overlayEntry;
  AnimationController controllerShowOffset;
  OverlayState overlayState;
  bool dismissed = false;
  _show() async {
    overlayState.insert(overlayEntry);
    controllerShowOffset.forward();
    await Future.delayed(Duration(milliseconds: 35000));
    this.dismiss();
  }

  dismiss() async {
    if (dismissed) {
      return;
    }
    this.dismissed = true;
    controllerShowOffset.reverse();
    await Future.delayed(Duration(milliseconds: 250));
    overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  final Widget child;
  final Animation<double> offsetAnim;
  ToastWidget({this.child, this.offsetAnim});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: offsetAnim,
        builder: (context, _) {
          return Transform.translate(
            offset: Offset(0, offsetAnim.value),
            child: child,
          );
        });
  }
}
