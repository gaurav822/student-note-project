import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Screens/Authscreens/loginUI.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';
import 'package:student_notes/Widgets/custom_tf_signup.dart';

// ignore: must_be_immutable
class ResetPasswordScreen extends StatefulWidget {
  final String link;
  ResetPasswordScreen(this.link);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController repasswordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is Required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'at least one special character must be present')
  ]);

  String password;

  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Reset Password"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(top: 30),
          child: Center(
            child: Column(
              children: [
                CustomTextField(
                    obsecure: !visibility,
                    onchanged: (val) => password = val,
                    label: "Enter new password",
                    prefixIcon: Icon(Icons.vpn_key),
                    valfunction: passwordValidator,
                    suffixIcon: InkWell(
                      onTap: _changeVisibility,
                      child: Icon(
                        !visibility ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    textEditingController: passwordController),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    obsecure: true,
                    label: "Re-enter password",
                    valfunction: (val) =>
                        MatchValidator(errorText: 'passwords do not match')
                            .validateMatch(val, password),
                    prefixIcon: Icon(Icons.vpn_key),
                    textEditingController: repasswordController),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: primaryColor, shape: StadiumBorder()),
                    onPressed: () {
                      // Get.offAll(LoginScreen());
                      if (_formKey.currentState.validate()) {
                        changePasswordProgress(context);
                      } else {}
                    },
                    child: Text(
                      "Change Password",
                      style: GoogleFonts.ubuntu(
                          textStyle:
                              TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remembered password ?",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.offAll(LoginScreen());
                        passwordController.clear();
                        repasswordController.clear();
                        _formKey.currentState.reset();
                      },
                      child: Text(
                        "Login",
                        style:
                            TextStyle(color: Color(0xff9C4040), fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changePasswordProgress(BuildContext context) async {
    String tokenValue = widget.link.substring(
        widget.link.lastIndexOf("/") + 1, widget.link.lastIndexOf("/") + 25);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
              onWillPop: () async => false, child: LoadingDialog());
        });
    try {
      String res = await AuthHelper.resetPasswordViaEmail(
          passwordController.text.trim(), "MTM", tokenValue);
      if (res == "200") {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Password Changed Successfully",
            backgroundColor: Colors.green);
        Get.offAll(LoginScreen());
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Reset Link has expired...", backgroundColor: Colors.red);
      }
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }

  _changeVisibility() {
    if (!visibility)
      visibility = true;
    else
      visibility = false;
    setState(() {});
  }
}
