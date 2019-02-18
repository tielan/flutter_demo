import 'package:flutter/material.dart';
import 'toast.dart';

class HUD {
  static showToast(BuildContext context, String msg) {
      Toast.show(context, msg);
  }
}
