import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Widgets/custom_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'This field is Required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  final emailValidator = EmailValidator(errorText: "Invalid Email address");
  String password;

  bool _showpass = false;

  String countryCode = "+977";

  ButtonState _buttonState = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800));
    return WillPopScope(
      onWillPop: () async {
        if (_buttonState == ButtonState.idle) {
          return true;
        } else {
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
            body: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                      Text("Learn & Smash.",
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(fontSize: 28),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(children: [
                    CustomTextField(
                      valfunction: (String value) {
                        if (value.isEmpty) {
                          return "This Field is Required";
                        } else if (value.length > 30) {
                          return "username can have maximum 30 character";
                        } else if (value.length < 6) {
                          return "username must have minimum 6 character";
                        }
                      },
                      textEditingController: usernameController,
                      label: "username",
                      prefixIcon: Icon(
                        FontAwesomeIcons.userAlt,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      valfunction: (String value) {
                        if (value.isEmpty) {
                          return "This Field is Required";
                        }
                      },
                      textEditingController: nameController,
                      label: "Full Name",
                      prefixIcon: Icon(
                        FontAwesomeIcons.userEdit,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      valfunction: (String value) {
                        if (value.isEmpty) {
                          return "This Field is Required";
                        } else if (!value.isEmail) {
                          return "Invalid Email Address";
                        }
                      },
                      textEditingController: emailController,
                      label: "Email Address",
                      prefixIcon: Icon(
                        Icons.mail,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      valfunction: (String value) {
                        if (value.isEmpty) {
                          return "This Field is Required";
                        } else if (value.length > 20) {
                          return "Invalid Phone Number";
                        }
                      },
                      textEditingController: phoneController,
                      label: "Phone number",
                      prefixIcon: CountryCodePicker(
                        onChanged: (e) {
                          setState(() {
                            countryCode = e.toString();
                          });
                        },

                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'NP',
                        textStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        favorite: ['+977', 'NP'],

                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        valfunction: passwordValidator,
                        textEditingController: passwordController,
                        label: "Password",
                        obsecure: !_showpass,
                        onchanged: (val) => password = val,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              if (!_showpass) {
                                _showpass = true;
                              } else {
                                _showpass = false;
                              }
                              setState(() {});
                            },
                            child: Icon(
                              _showpass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: Get.width * .7,
                      child: TextFormField(
                        controller: repasswordController,
                        validator: (val) =>
                            MatchValidator(errorText: 'passwords do not match')
                                .validateMatch(val, password),
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        cursorHeight: 22,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState.validate() &&
                              _buttonState == ButtonState.idle) {
                            _buttonState = ButtonState.loading;
                            setState(() {});
                            _registerProgress(context);
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            border: border,
                            enabled: true,
                            focusedBorder: border,
                            enabledBorder: border,
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            hintText: "Re-enter Password",
                            filled: true),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                                  text: "Register",
                                  icon: Icon(Icons.fact_check,
                                      color: Colors.white),
                                  color: Color(0xfff06315c)),
                              ButtonState.loading: IconedButton(
                                  text: "Registering",
                                  color: Color(0xfff06315c)),
                              ButtonState.fail: IconedButton(
                                  text: "Failed",
                                  icon: Icon(Icons.cancel, color: Colors.white),
                                  color: Colors.red.shade300),
                              ButtonState.success: IconedButton(
                                  text: "Registered",
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  color: Colors.green.shade400)
                            },
                            onPressed: () {
                              if (_formKey.currentState.validate() &&
                                  _buttonState == ButtonState.idle) {
                                _buttonState = ButtonState.loading;
                                setState(() {});
                                _registerProgress(context);
                              }
                            },
                            state: _buttonState)),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already a User ?",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Login",
                              style: TextStyle(
                                  color: Color(0xff9C4040), fontSize: 18)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  void _registerProgress(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String name = nameController.text.toString().trim();
    String number = countryCode + phoneController.text.toString().trim();
    String username = usernameController.text.toString().trim();

    var user =
        await AuthHelper.createUser(username, name, email, number, password);
    // setState(() {
    //   _userModel = user;
    // });
    if (user == "201") {
      Future.delayed(Duration(seconds: 3)).then((value) {
        Navigator.of(context).pop();
      });
      setState(() {
        _buttonState = ButtonState.success;
      });
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg:
              "Don't forget to verify your email address. hint: check spam folder",
          backgroundColor: Colors.green);
    } else if (user == "404") {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _buttonState = ButtonState.idle;
        });
      });

      setState(() {
        _buttonState = ButtonState.fail;
      });
      Fluttertoast.showToast(
          msg: "Please check internet connection", backgroundColor: Colors.red);
    } else if (user.contains("username") && user.contains("email")) {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _buttonState = ButtonState.idle;
        });
      });

      setState(() {
        _buttonState = ButtonState.fail;
      });
      Fluttertoast.showToast(
          msg: "username or email already exists", backgroundColor: Colors.red);
    } else {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _buttonState = ButtonState.idle;
        });
      });

      setState(() {
        _buttonState = ButtonState.fail;
      });
      Fluttertoast.showToast(msg: user, backgroundColor: Colors.red);
    }
  }
}
