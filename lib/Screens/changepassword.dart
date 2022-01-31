import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Utils/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldpassController = TextEditingController();
  TextEditingController newpassController = TextEditingController();
  TextEditingController renewpassController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is Required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  IconData _initialIcon1 = Icons.visibility_off;
  IconData _initialIcon2 = Icons.visibility_off;

  IconData _initialIcon3 = Icons.visibility_off;

  bool _visible1 = false;
  bool _visible2 = false;
  bool _visible3 = false;

  final oldPassValidator = MinLengthValidator(8,
      errorText: 'password must be at least 8 digits long');

  String password;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(10));
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backColor,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Change Password",
                        style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      // controller: textEditingController,
                      validator: oldPassValidator,
                      obscureText: !_visible1,
                      controller: oldpassController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: tfColor,
                          ),
                          suffixIcon: InkWell(
                              onTap: _firstvisibilityChange,
                              child: Icon(
                                _initialIcon1,
                                color: Colors.black,
                              )),
                          border: border,
                          focusedBorder: border,
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hintText: "Enter old password"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      // controller: textEditingController,
                      validator: passwordValidator,
                      controller: newpassController,
                      onChanged: (value) => password = value,
                      obscureText: !_visible2,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: tfColor,
                          ),
                          suffixIcon: InkWell(
                              onTap: _secondvisibilityChange,
                              child: Icon(
                                _initialIcon2,
                                color: Colors.black,
                              )),
                          border: border,
                          focusedBorder: border,
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hintText: "Enter new password"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      // controller: textEditingController,
                      validator: (val) =>
                          MatchValidator(errorText: 'passwords do not match')
                              .validateMatch(val, password),
                      controller: renewpassController,
                      obscureText: !_visible3,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: tfColor,
                          ),
                          suffixIcon: InkWell(
                            child: Icon(
                              _initialIcon3,
                              color: Colors.black,
                            ),
                            onTap: _thirdvisibilityChange,
                          ),
                          border: border,
                          focusedBorder: border,
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hintText: "Re-enter new password"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: primaryColor),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _changePasswordProgress(context);
                          } else {
                            print("this");
                          }
                        },
                        child: Text(
                          "Submit",
                          style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  _changePasswordProgress(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    String oldpass = oldpassController.text.toString().trim();
    String pass1 = newpassController.text.toString().trim();
    String pass2 = renewpassController.text.toString().trim();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              content: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Changing Password"),
                  SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ));

    var response = await AuthHelper.changePassword(oldpass, pass1, pass2);
    print(response);
    if (response == "200") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Password Changed Successfully!");
      Navigator.of(context).pop();
    } else if (response.contains("old_password")) {
      Navigator.of(context).pop();

      Fluttertoast.showToast(msg: "Old Password is Not Correct !");
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: response.toString());
    }
  }

  void _firstvisibilityChange() {
    if (!_visible1) {
      _initialIcon1 = (Icons.visibility);
      _visible1 = true;
    } else {
      _initialIcon1 = (Icons.visibility_off);
      _visible1 = false;
    }
    setState(() {});
  }

  void _secondvisibilityChange() {
    if (!_visible2) {
      _initialIcon2 = (Icons.visibility);
      _visible2 = true;
    } else {
      _initialIcon2 = (Icons.visibility_off);
      _visible2 = false;
    }
    setState(() {});
  }

  void _thirdvisibilityChange() {
    if (!_visible3) {
      _initialIcon3 = (Icons.visibility);
      _visible3 = true;
    } else {
      _initialIcon3 = (Icons.visibility_off);
      _visible3 = false;
    }
    setState(() {});
  }
}
