import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';

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
        insetPadding: EdgeInsets.all(5),
        contentPadding: EdgeInsets.all(10),
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: widget.textEditingController,
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              cursorHeight: 20,
              onFieldSubmitted: (value) {
                _validateField(context);
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: tfColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    color: tfColor,
                    onPressed: () {
                      if (widget.textEditingController.text.isNotEmpty) {
                        widget.textEditingController.clear();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please enter something",
                            backgroundColor: Colors.red);
                      }
                    },
                  ),
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                  // filled: true,
                  fillColor: backColor,
                  focusColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: "Enter your email"),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: primaryColor),
              onPressed: () {
                _validateField(context);
              },
              child: Text("Submit",
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
          ),
          Row(
            children: [Container(width: Get.width)],
          ),
        ],
        titlePadding: EdgeInsets.only(
          bottom: 20,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              "Forgot your ${this.widget.forgotText} ?",
              style: TextStyle(color: Colors.black),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ))
          ],
        ));
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
                onWillPop: () async => false, child: LoadingDialog());
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
