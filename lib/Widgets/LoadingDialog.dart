import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String loadText;
  LoadingDialog({this.loadText = "Please wait..."});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          Text(loadText),
          SizedBox(
            width: 30,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
