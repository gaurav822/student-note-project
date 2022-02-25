import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Utils {
  static void showTopSnackBar(
          BuildContext context, String message, Color color) =>
      showSimpleNotification(
          Text(
            "Internet Connection",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          subtitle: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          background: color);
}
