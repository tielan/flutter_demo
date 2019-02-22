import 'package:flutter/material.dart';
import 'src/location_picker.dart';
import 'src/selected_picker.dart';
import 'timepicker/flutter_datetime_picker.dart';

class Picker {
  static showSelectPicker(BuildContext context,
      {@required List listData,
      int initSelected = 0,
      SelectPickerChangedCallback onConfirm}) {
    SelectPickerModel.show(context,
        listData: listData, initSelected: initSelected, onConfirm: onConfirm);
  }

  static showLocationPicker(
    BuildContext context, {
    bool showTitleActions: true,
    String initialNames,
    initialProvince: '湖南省',
    initialCity: '长沙市',
    initialTown: '雨花区',
    LocationChangedCallback onChanged,
    LocationChangedCallback onConfirm,
  }) {
    LocationPicker.showPicker(context,
        showTitleActions: showTitleActions,
        initialNames: initialNames,
        initialProvince: initialProvince,
        initialCity: initialCity,
        initialTown: initialTown,
        onChanged: onChanged,
        onConfirm: onConfirm);
  }

  static void showDatePicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime minTime,
    DateTime maxTime,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateTime currentTime,
    DatePickerTheme theme,
  }) {
    DatePicker.showDatePicker(context,
        showTitleActions: showTitleActions,
        minTime: minTime,
        maxTime: maxTime,
        onChanged: onChanged,
        onConfirm: onConfirm,
        currentTime: currentTime,
        locale: LocaleType.zh,
        theme: theme);
  }
}
