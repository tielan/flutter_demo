import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef SelectPickerChangedCallback(List names, int selectedIndex);

const double _kPickerHeight = 220.0;
const double _kPickerTitleHeight = 44.0;
const double _kPickerItemHeight = 40.0;

class SelectPickerModel {
  static void show(BuildContext context,
      {@required List listData,
      int initSelected = 0,
      SelectPickerChangedCallback onConfirm}) {
    Navigator.push(
        context,
        new SelectPickerModelRoute(
          listData: listData,
          initSelected: initSelected,
          onConfirm: onConfirm,
          theme: Theme.of(context, shadowThemeOnly: true),
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }
}

class SelectPickerModelRoute<T> extends PopupRoute<T> {
  SelectPickerModelRoute({
    this.listData,
    this.initSelected,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);
  final List listData;
  final int initSelected;
  final SelectPickerChangedCallback onConfirm;
  final ThemeData theme;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
  @override
  bool get barrierDismissible => true;
  @override
  final String barrierLabel;
  @override
  Color get barrierColor => Colors.black54;
  AnimationController _animationController;
  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _SelectPickerModelComponent(
          route: this, listData: listData, initSelected: initSelected),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _SelectPickerModelComponent extends StatefulWidget {
  _SelectPickerModelComponent({
    Key key,
    this.listData,
    this.initSelected = 0,
    @required this.route,
  });

  final List listData;
  final int initSelected;
  final SelectPickerModelRoute route;

  @override
  ___SelectPickerModelComponentState createState() {
    return ___SelectPickerModelComponentState();
  }
}

class ___SelectPickerModelComponentState extends State<_SelectPickerModelComponent> {
  FixedExtentScrollController scrollCtrl;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initSelected;
    scrollCtrl =
        new FixedExtentScrollController(initialItem: widget.initSelected);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomSelectPickerModelLayout(
                  widget.route.animation.value,
                  showTitleActions: true),
              child: new GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: _kPickerTitleHeight,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: _kPickerTitleHeight,
                              child: FlatButton(
                                child: Text(
                                  '取消',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Container(
                              height: _kPickerTitleHeight,
                              child: FlatButton(
                                child: Text(
                                  '确定',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                onPressed: () {
                                  if (widget.route.onConfirm != null) {
                                    widget.route.onConfirm(
                                        widget.listData, currentIndex);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        height: _kPickerHeight,
                        decoration: BoxDecoration(color: Colors.white),
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          scrollController: scrollCtrl,
                          itemExtent: _kPickerItemHeight,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          children: List.generate(widget.listData.length,
                              (int index) {
                            String text = widget.listData[index];
                            return Container(
                              height: _kPickerItemHeight,
                              alignment: Alignment.center,
                              child: Text(
                                '$text',
                                style: TextStyle(
                                    color: Color(0xFF000046),
                                    fontSize: _pickerFontSize(text)),
                                textAlign: TextAlign.start,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _pickerFontSize(String text) {
    double ratio = 0.0;
    if (text == null || text.length <= 6) {
      return 18.0;
    } else if (text.length < 9) {
      return 16.0 + ratio;
    } else if (text.length < 13) {
      return 12.0 + ratio;
    } else {
      return 10.0 + ratio;
    }
  }
}

class _BottomSelectPickerModelLayout extends SingleChildLayoutDelegate {
  _BottomSelectPickerModelLayout(this.progress,
      {this.itemCount, this.showTitleActions});
  final double progress;
  final int itemCount;
  final bool showTitleActions;
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = _kPickerHeight;
    if (showTitleActions) {
      maxHeight += _kPickerTitleHeight;
    }
    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomSelectPickerModelLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
