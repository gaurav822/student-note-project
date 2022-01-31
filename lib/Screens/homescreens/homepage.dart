import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Api/userhelper.dart';
import 'package:student_notes/Models/user_model.dart';
import 'package:student_notes/Screens/homescreens/tabs/browsecoursestab.dart';
import 'package:student_notes/Screens/homescreens/tabs/contactus.dart';
import 'package:student_notes/Screens/homescreens/tabs/hometab.dart';
import 'package:student_notes/Screens/homescreens/tabs/mycoursestab.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Utils/internetutils.dart';
import 'package:student_notes/Widgets/appbar.dart';
import 'package:student_notes/Widgets/customdrawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _userName, _imageUrl;
  int _currentIndex = 0;
  StreamSubscription subscription;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    findUserName();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      findImageUrl();
    });
    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
  }

  Future<void> findUserName() async {
    final uname = await SecuredStorage.getUserName();
    _userName = uname;
    setState(() {});
  }

  Future<void> findImageUrl() async {
    UserModel userModel = await UserHelper.getUserInfo();
    String imageUrl = userModel.image;
    _imageUrl = imageUrl;
    setState(() {});
  }

  @override
  void dispose() {
    subscription.cancel();
    _timer?.cancel();
    print("Timer is cancelled now");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: customAppBar(context, _userName, _currentIndex),
        drawer: CustomDrawer(_imageUrl),
        backgroundColor: backColor,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          iconSize: 30,
          selectedFontSize: 16,
          currentIndex: _currentIndex,
          onTap: (index) => {
            setState(() {
              _currentIndex = index;
            })
          },
          fixedColor: Colors.blue,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "My Courses",
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Browse",
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone),
              label: "Contact",
              backgroundColor: primaryColor,
            ),
          ],
        ),
        body: IndexedStack(
          children: [
            HomeTab(),
            MyCourse(),
            BrowseCourse(),
            ContactUsPage(_userName),
          ],
          index: _currentIndex,
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String deg, List slclist) {
    return Container(
      color: Colors.white,
      child: ExpansionTile(
        title: Text(deg),
        textColor: Colors.brown,
        collapsedTextColor: Colors.black,
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        children: [
          for (int i = 0; i < slclist.length; i++)
            ExpansionTile(title: Text(slclist[i]))
        ],
      ),
    );
  }

  void showConnectivitySnackBar(ConnectivityResult result) async {
    final hasInternet = result != ConnectivityResult.none;

    if (!hasInternet) {
      print("printing from here");
      final message = 'Please check your internet connection';
      Utils.showTopSnackBar(context, message, Colors.red);
    } else {
      String res = await AuthHelper.updateAccessToken();
    }
  }
}
