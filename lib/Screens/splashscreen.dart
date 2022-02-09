import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Screens/homescreens/homepage.dart';
import 'package:student_notes/Screens/loginUI.dart';
import 'package:student_notes/Screens/reset_passscreen.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';
import 'package:student_notes/Utils/colors.dart';
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
  String email;

  bool _hasInternet = false;

  StreamSubscription subscription;

  String link = "";

  Future<String> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();

      // print("The value of link is " + initialLink);
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
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

    checkInternetConnection();
    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    findUserState();
    Timer(Duration(seconds: 4), () {
      if (_hasInternet) {
        link == null
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        (email != null) ? MyHomePage() : LoginScreen()))
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => ResetPasswordScreen(link)));
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: new Text('Internet Problem'),
              content: new Text('Please refresh your internet to continue'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("Refresh"),
                  onPressed: () async {
                    if (_hasInternet) {
                      if (email != null) {
                        await AuthHelper.updateAccessToken();
                        Fluttertoast.showToast(
                            msg: "Token refreshed from upper point");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => MyHomePage()));
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      }
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => (email != null)
                                  ? MyHomePage()
                                  : LoginScreen()));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Poor connection", backgroundColor: Colors.red);
                    }
                  },
                ),
              ],
            ),
          ),
        );
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

  Future<void> findUserState() async {
    final access = await SecuredStorage.getEmail();
    email = access;
    setState(() {});
  }

  @override
  void dispose() {
    subscription.cancel();
    _iconController.dispose();

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

  void checkInternetConnection() async {
    final email = await SecuredStorage.getEmail();
    final result = await Connectivity().checkConnectivity();
    final hasInternet = result != ConnectivityResult.none;
    if (!hasInternet) {
      final String message = 'Please check your internet connection';
      var snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (email != null) {
        await AuthHelper.updateAccessToken();
      }
    }
  }
}
