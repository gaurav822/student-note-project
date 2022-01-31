import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Utils/colors.dart';

// ignore: must_be_immutable
class ForgotDialog extends StatefulWidget {
  TextEditingController textEditingController = TextEditingController();
  String forgotText;
  ForgotDialog({Key key, this.textEditingController, this.forgotText})
      : super(key: key);

  @override
  State<ForgotDialog> createState() => _ForgotDialogState();
}

class _ForgotDialogState extends State<ForgotDialog> {
  @override
  void initState() {
    super.initState();
    widget.textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(10));
    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: widget.textEditingController,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: tfColor,
                ),
                border: border,
                focusedBorder: border,
                filled: true,
                focusColor: Colors.white,
                hintText: "Enter your email"),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: primaryColor),
            onPressed: () {
              _validateField(context);
            },
            child: Text("Submit"),
          ),
        ),
        Row(
          children: [Container(width: Get.width)],
        ),
      ],
      title: Center(
        child: Text(
          "Forgot your ${this.widget.forgotText} ?",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  _validateField(BuildContext context) {
    String email = widget.textEditingController.text.toString().trim();

    if (email.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email cannot be blank", backgroundColor: Colors.red);
    } else if (!email.isEmail) {
      Fluttertoast.showToast(
          msg: "Invalid email format", backgroundColor: Colors.red);
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Please wait..."),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
          });

      _sendResetPasswordEmail(email, context);
    }
  }

  void _sendResetPasswordEmail(String email, BuildContext context) async {
    String statusCode = await AuthHelper.sendResetPasswordEmail(email);

    if (statusCode == "200") {
      widget.textEditingController.clear();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Please check your email now",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green);
    } else if (statusCode == "404") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "User with this email doesn't exist",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG);
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Please check internet connection",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
