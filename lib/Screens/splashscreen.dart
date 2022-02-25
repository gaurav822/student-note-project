import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Screens/homescreens/main_tab.dart';
import 'package:student_notes/Screens/Authscreens/loginUI.dart';
import 'package:student_notes/Screens/Authscreens/reset_passscreen.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/provider/profileprovider.dart';
import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  //for upper icon animation
  AnimationController _iconController;
  Animation<Offset> _iconanimation;
  //for lower text animation
  AnimationController _textcontroller;
  Animation<Offset> _textanimation;
  String accessToken;
  bool _hasInternet = false;
  StreamSubscription subscription;
  String link = "";

  Future<String> initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      return initialLink;
    } on PlatformException {
      Fluttertoast.showToast(msg: "Failed");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    initUniLinks().then((value) => this.setState(() {
          link = value;
        }));
    checkUserSession();
    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    Timer(Duration(seconds: 4), () async {
      if (link != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => ResetPasswordScreen(link)));
      } else {
        if (accessToken == null) {
          Get.offAll(() => LoginScreen());
        } else {
          if (_hasInternet) {
            gotoHomePage();
          } else {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: new Text('Internet Problem'),
                  content: new Text('Click on refresh button to continue'),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: primaryColor),
                      child: Text(
                        "Refresh",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_hasInternet) {
                          gotoHomePage();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please check your internet again",
                              fontSize: 17,
                              backgroundColor: Colors.red);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }
    });
    //for upper icon
    _iconController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _iconanimation =
        Tween<Offset>(begin: Offset(0, -0.5), end: Offset(0.0, 0.1))
            .animate(_iconController);
    _iconController.forward();

    //begin Offset(0,-0.5) means x axis 0 and y axis start beyond screen from above

    //for lower text

    _textcontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _textanimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, -1))
        .animate(_textcontroller);
    _textcontroller.forward();
  }

  Future<void> checkUserSession() async {
    final access = await SecuredStorage.getAccess();
    accessToken = access;
    setState(() {});
  }

  @override
  void dispose() {
    subscription.cancel();
    _iconController.dispose();
    _textcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: SlideTransition(
              position: _iconanimation,
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Image.asset("assets/icon/icon.png"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _textanimation,
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Text(
                  "ISCMentor",
                  style: GoogleFonts.stylish(
                    textStyle: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    _hasInternet = hasInternet;
    setState(() {});
  }

  void gotoHomePage() async {
    await AuthHelper.updateAccessToken();
    final accesstok = await SecuredStorage.getAccess();
    final refreshtok = await SecuredStorage.getRefresh();
    final username = await SecuredStorage.getUserName();
    final email = await SecuredStorage.getEmail();
    if (mounted) {
      Provider.of<ProfileProvider>(context, listen: false).tokenSet(
          access: accesstok,
          refresh: refreshtok,
          email: email,
          username: username);
    }
    Get.offAll(() => MyHomePage());
  }
}
