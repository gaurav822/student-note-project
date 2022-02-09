import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Api/googlesigninhelper.dart';
import 'package:student_notes/Screens/registerUI.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';
import 'package:get/get.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';
import 'package:student_notes/Widgets/custom_page_route.dart';
import 'package:student_notes/Screens/homescreens/homepage.dart';
import 'package:student_notes/Widgets/custom_textfield.dart';
import 'package:student_notes/Widgets/forgotDialogbox.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool visibility = false;
  var _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is Required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long')
  ]);

  ButtonState _buttonState = ButtonState.idle;

  @override
  void initState() {
    super.initState();
    _buttonState = ButtonState.idle;
    _clear();
  }

  Future<void> _clear() async {
    Future.delayed(Duration(seconds: 5)).then((value) async {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:
          _buttonState == ButtonState.idle ? _onBackPressed : () async => false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      Text("Let's Sign you in.",
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(fontSize: 28),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  _loginPart(),
                  // Spacer(),
                  SizedBox(
                    height: 150,
                  ),
                  Container(
                    height: 45,
                    width: 230,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xfff06315c)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FontAwesomeIcons.google, color: Colors.white),
                          Text(
                            "Sign in with Google",
                            style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )
                        ],
                      ),
                      onPressed: () {
                        _googleSignIn();
                      },
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  _bottomPart(),

                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _googleSignIn() async {
    try {
      final user = await GoogleSignInHelper.login();
      if (user != null) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => WillPopScope(
                onWillPop: () async => false, child: LoadingDialog()));
        final GoogleSignInAuthentication googleAuth = await user.authentication;
        log("The new id token" + googleAuth.idToken);
        await SecuredStorage.setGAuthKey(googleAuth.idToken);
        String res =
            await AuthHelper.googleSignIn(authToken: googleAuth.idToken);
        print("This is res " + res);
        if (res == "200") {
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Login Successful", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ));

          Navigator.of(context).push(CustomPageRoute(
              child: MyHomePage(), direction: AxisDirection.right));
        } else {
          Navigator.of(context).pop();
          await GoogleSignInHelper.logout();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "User already exists: Please signin with email and password",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Login Failed",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } on PlatformException catch (err) {
      print("Calling catcher 1");
      print(err.toString());
    } catch (e) {
      print("Calling catcher 2");
      print(e.toString());
    }
  }

  Widget _bottomPart() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have account ?",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(CustomPageRoute(
                    child: RegistrationScreen(),
                    direction: AxisDirection.right));
                usernameController.clear();
                passController.clear();
                _formKey.currentState.reset();
              },
              child: Text("Register",
                  style: TextStyle(color: Color(0xff9C4040), fontSize: 18)),
            )
          ],
        ),
        SizedBox(
          height: 70,
        )
      ],
    );
  }

  Widget _loginPart() {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800));
    return Form(
        key: _formKey,
        child: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                  width: Get.width * .7,
                  child: CustomTextField(
                    textEditingController: usernameController,
                    valfunction: (String value) {
                      if (value.isEmpty) {
                        return "This Field is Required";
                      }
                    },
                    label: "Username",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: Get.width * .7,
                  child: TextFormField(
                    controller: passController,
                    validator: passwordValidator,
                    obscureText: !visibility,
                    cursorHeight: 22,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      loginProgress();
                    },
                    decoration: InputDecoration(
                        border: border,
                        focusedBorder: border,
                        enabledBorder: border,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: InkWell(
                          onTap: _changeVisibility,
                          child: Icon(
                            !visibility
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        hintText: "Password",
                        filled: true),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot ",
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return new ForgotDialog(
                                      textEditingController: emailController,
                                      forgotText: "Username",
                                    );
                                  });
                            },
                            child: Text(
                              "Username ",
                              style: TextStyle(
                                  color: Color(0xff9C4040), fontSize: 16),
                            ),
                          ),
                          Text(
                            "or ",
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return new ForgotDialog(
                                      textEditingController: emailController,
                                      forgotText: "Password",
                                    );
                                  });
                            },
                            child: Text(
                              "Password ",
                              style: TextStyle(
                                  color: Color(0xff9C4040), fontSize: 16),
                            ),
                          ),
                          Text("?"),
                        ],
                      )),
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                    width: Get.width * .5,
                    height: 50,
                    child: ProgressButton.icon(
                        textStyle: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        iconedButtons: {
                          ButtonState.idle: IconedButton(
                              icon: Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                              text: "Login",
                              color: Color(0xfff06315c)),
                          ButtonState.loading: IconedButton(
                              text: "Logging in", color: Color(0xfff06315c)),
                          ButtonState.fail: IconedButton(
                              text: "Failed",
                              icon: Icon(Icons.cancel, color: Colors.white),
                              color: Colors.red.shade300),
                          ButtonState.success: IconedButton(
                              text: "Success",
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              color: Colors.green.shade400)
                        },
                        onPressed: () {
                          if (_buttonState == ButtonState.idle) {
                            loginProgress();
                          }
                        },
                        state: _buttonState))
              ],
            ),
          ),
        ));
  }

  Future<void> loginProgress() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (_formKey.currentState.validate()) {
      _buttonState = ButtonState.loading;
      setState(() {});
      String statusCode = await AuthHelper.login(
          usernameController.text.toString(), passController.text.toString());

      print("This is statuscode" + statusCode);

      if (statusCode == "200") {
        Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.of(context).push(CustomPageRoute(
              child: MyHomePage(), direction: AxisDirection.right));
        });
        _buttonState = ButtonState.success;
        setState(() {});
      } else if (statusCode == "400") {
        Future.delayed(Duration(seconds: 3)).then((value) {
          _buttonState = ButtonState.idle;
          setState(() {});
        });
        _buttonState = ButtonState.fail;
        setState(() {});
        Fluttertoast.showToast(
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
            msg:
                "please verify your email address first. hint: check spam folder");
      } else if (statusCode == "404") {
        Future.delayed(Duration(seconds: 3)).then((value) {
          _buttonState = ButtonState.idle;
          setState(() {});
        });
        _buttonState = ButtonState.fail;
        setState(() {});
        Fluttertoast.showToast(
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
            msg: "Please check internet Connection");
      } else {
        Future.delayed(Duration(seconds: 3)).then((value) {
          _buttonState = ButtonState.idle;
          setState(() {});
        });
        _buttonState = ButtonState.fail;
        setState(() {});
        Fluttertoast.showToast(
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
            msg: "username or password is incorrect");
      }
    }
  }

  _changeVisibility() {
    if (!visibility)
      visibility = true;
    else
      visibility = false;
    setState(() {});
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit from app '),
            actions: <Widget>[
              new InkWell(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new InkWell(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
