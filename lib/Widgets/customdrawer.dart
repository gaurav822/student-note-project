import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Api/googlesigninhelper.dart';
import 'package:student_notes/Screens/changepassword.dart';
import 'package:student_notes/Screens/homescreens/profile/profilepage.dart';
import 'package:student_notes/Screens/loginUI.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';
import 'package:student_notes/Widgets/custom_page_route.dart';

class CustomDrawer extends StatelessWidget {
  final String _imageUrl;
  CustomDrawer(this._imageUrl);
  @override
  Widget build(BuildContext context) {
    TextStyle style = GoogleFonts.ubuntu(fontSize: 16);

    return Drawer(
      child: Container(
        // color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                  height: 150,
                  color: primaryColor,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: (Image.network(
                          _imageUrl != null
                              ? _imageUrl
                              : "https://api.iscmentor.com/media/profile_img/default.jpg",
                          height: 110,
                          width: 120,
                          fit: BoxFit.fitWidth,
                        )),
                      )
                    ],
                  )),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                },
                title: Text(
                  "Home",
                  style: style,
                ),
                leading: Icon(
                  Icons.home,
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).pop();
                  Navigator.of(context).push(CustomPageRoute(
                      child: ProfilePage(), direction: AxisDirection.right));
                },
                title: Text(
                  "Profile",
                  style: style,
                ),
                leading: Icon(
                  Icons.person,
                ),
              ),
              ExpansionTile(
                title: Text(
                  "Settings",
                  style: style,
                ),
                leading: Icon(
                  Icons.settings,
                ),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Change Password",
                      style: style,
                    ),
                    onTap: () {
                      Navigator.of(context).push(CustomPageRoute(
                          child: ChangePassword(),
                          direction: AxisDirection.right));
                    },
                    leading: Icon(Icons.vpn_key),
                  ),
                ],
              ),
              Spacer(),
              ListTile(
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => LoadingDialog(
                            loadText: "Logging out...",
                          ));

                  String res = await AuthHelper.logout();

                  if (res == "204") {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);

                    final gAuthKey = await SecuredStorage.getGAuthKey();
                    if (gAuthKey != null) {
                      await GoogleSignInHelper.logout();
                    }
                    await SecuredStorage.clear();
                    EasyLoading.showSuccess("Logout Successful");
                  } else {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(msg: "There is a Problem");
                  }
                },
                title: Text(
                  "Logout",
                  style: GoogleFonts.ubuntu(color: Colors.red, fontSize: 16),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
