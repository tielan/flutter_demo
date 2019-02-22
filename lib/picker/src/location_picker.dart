import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import './location.dart';

typedef LocationChangedCallback(String names, String code);

const double _kPickerHeight = 220.0;
const double _kPickerTitleHeight = 44.0;
const double _kPickerItemHeight = 40.0;

class LocationPicker {
  static void showPicker(
    BuildContext context, {
    bool showTitleActions: true,
    String initialNames,
    initialProvince: '湖南省',
    initialCity: '长沙市',
    initialTown: '雨花区',
    LocationChangedCallback onChanged,
    LocationChangedCallback onConfirm,
  }) async {
    if (Locations.locations == null) {
      String regionData = await rootBundle.loadString("data/region.json");
      Locations.setLocations(json.decode(regionData));
    }
    if (initialNames != null) {
      List<String> names = initialNames.split(',');
      if (names.length == 1) {
        initialProvince = names[0];
      } else if (names.length == 2) {
        initialProvince = names[0];
        initialCity = names[1];
      } else if (names.length == 3) {
        initialProvince = names[0];
        initialCity = names[1];
        initialTown = names[2];
      }
    }

    Navigator.push(
        context,
        new _PickerRoute(
          showTitleActions: showTitleActions,
          initialProvince: initialProvince,
          initialCity: initialCity,
          initialTown: initialTown,
          onChanged: onChanged,
          onConfirm: onConfirm,
          theme: Theme.of(context, shadowThemeOnly: true),
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }
}

class _PickerRoute<T> extends PopupRoute<T> {
  _PickerRoute({
    this.showTitleActions,
    this.initialProvince,
    this.initialCity,
    this.initialTown,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final bool showTitleActions;
  final String initialProvince, initialCity, initialTown;
  final LocationChangedCallback onChanged;
  final LocationChangedCallback onConfirm;
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
      child: _PickerComponent(
        initialProvince: initialProvince,
        initialCity: initialCity,
        initialTown: initialTown,
        onChanged: onChanged,
        route: this,
      ),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }

    return bottomSheet;
  }
}

class _PickerComponent extends StatefulWidget {
  _PickerComponent({
    Key key,
    this.initialProvince,
    this.initialCity,
    this.initialTown,
    @required this.route,
    this.onChanged,
  });

  final String initialProvince, initialCity, initialTown;
  final LocationChangedCallback onChanged;
  final _PickerRoute route;

  @override
  __PickerComponentState createState() {
    return __PickerComponentState();
  }
}

class __PickerComponentState extends State<_PickerComponent> {
  AnimationController controller;
  Animation<double> animation;
  FixedExtentScrollController provinceScrollCtrl;
  FixedExtentScrollController cityScrollCtrl;
  FixedExtentScrollController townScrollCtrl;

  List cities = [];
  List towns = [];
  List provinces = [];

  Map _currentProvince;
  Map _currentCity;
  Map _currentTown;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    int pindex = 0;
    int cindex = 0;
    int tindex = 0;

    provinces = Locations.getProvinces();
    pindex = Locations.getProvincesIndex(widget.initialProvince);
    var selectedProvince = provinces[pindex];
    if (selectedProvince != null) {
      _currentProvince = selectedProvince;

      cities = Locations.getCities(selectedProvince);
      cindex = Locations.getCitieIndex(widget.initialCity, cities);
      _currentCity = cities[cindex];

      towns = Locations.getTowns(cities[cindex]);
      if (towns != null && towns.length > 0) {
        tindex = Locations.getTownIndex(widget.initialTown, towns);
        _currentTown = towns[tindex];
      }
    }

    provinceScrollCtrl = new FixedExtentScrollController(initialItem: pindex);
    cityScrollCtrl = new FixedExtentScrollController(initialItem: cindex);
    townScrollCtrl = new FixedExtentScrollController(initialItem: tindex);
  }

  void _setProvince(int index) {
    Map selectedProvince = provinces[index];
    if (_currentProvince == null ||
        _currentProvince['value'] != selectedProvince['value']) {
      setState(() {
        _currentProvince = selectedProvince;

        cities = Locations.getCities(selectedProvince);
        _currentCity = cities[0];
        cityScrollCtrl.jumpToItem(0);

        towns = Locations.getTowns(cities[0]);
        _currentTown = towns.length == 0 ? null : towns[0];
        townScrollCtrl.jumpToItem(0);
      });
    }
  }

  void _setCity(int index) {
    index = cities.length > index ? index : cities.length - 1;
    Map selectedCity = cities[index];
    if (_currentCity == null ||
        _currentCity['value'] != selectedCity['value']) {
      setState(() {
        _currentCity = selectedCity;

        towns = Locations.getTowns(selectedCity);
        _currentTown = towns.length == 0 ? null : towns[0];
        townScrollCtrl.jumpToItem(0);
      });
    }
  }

  void _setTown(int index) {
    Map selectedTown = towns[index];
    if (_currentTown != null ||
        _currentTown['value'] != selectedTown['value']) {
      _currentTown = selectedTown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(widget.route.animation.value,
                  showTitleActions: widget.route.showTitleActions),
              child: new GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: _renderPickerView(),
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

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();
    if (widget.route.showTitleActions) {
      return Column(
        children: <Widget>[
          _renderTitleActionsView(),
          itemView,
        ],
      );
    }
    return itemView;
  }

  Widget _renderItemView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: _kPickerHeight,
            decoration: BoxDecoration(color: Colors.white),
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              scrollController: provinceScrollCtrl,
              itemExtent: _kPickerItemHeight,
              onSelectedItemChanged: (int index) {
                _setProvince(index);
              },
              children: List.generate(provinces.length, (int index) {
                String text = provinces[index]['value'];
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
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.all(8.0),
              height: _kPickerHeight,
              decoration: BoxDecoration(color: Colors.white),
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: cityScrollCtrl,
                itemExtent: _kPickerItemHeight,
                onSelectedItemChanged: (int index) {
                  _setCity(index);
                },
                children: List.generate(cities.length, (int index) {
                  String text = cities[index]['value'];
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
              )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.all(8.0),
              height: _kPickerHeight,
              decoration: BoxDecoration(color: Colors.white),
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: townScrollCtrl,
                itemExtent: _kPickerItemHeight,
                onSelectedItemChanged: (int index) {
                  _setTown(index);
                },
                children: List.generate(towns.length, (int index) {
                  String text = towns[index]['value'];
                  return Container(
                    height: _kPickerItemHeight,
                    alignment: Alignment.center,
                    child: Text(
                      "${text}",
                      style: TextStyle(
                          color: Color(0xFF000046),
                          fontSize: _pickerFontSize(text)),
                      textAlign: TextAlign.start,
                    ),
                  );
                }),
              )),
        )
      ],
    );
  }

  // Title View
  Widget _renderTitleActionsView() {
    return Container(
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
                  color: Theme.of(context).unselectedWidgetColor,
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
                  String names =
                      _currentProvince['value'] + ',' + _currentCity['value'];
                  String code =
                      _currentProvince['id'] + ',' + _currentCity['id'];
                  if (_currentCity['id'] != _currentTown['id']) {
                    //id
                    names += ',' + _currentTown['value'];
                    code += ',' + _currentTown['id'];
                  }
                  widget.route.onConfirm(names, code);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions});
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
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
