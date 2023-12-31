import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void toastMessage(String mess, Color bgColor) {
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
