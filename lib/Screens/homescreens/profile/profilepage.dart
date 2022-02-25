import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Api/userhelper.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Models/user_model.dart';
import 'package:student_notes/Screens/homescreens/profile/edit_profilepage.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/custom_page_route.dart';
import 'package:student_notes/Widgets/numbers_widget.dart';
import 'package:student_notes/Widgets/profile_widget.dart';
import 'package:student_notes/Widgets/shimmer_widget.dart';

import '../../../provider/profileprovider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextStyle smallTxStyle = GoogleFonts.ubuntu(
      textStyle: TextStyle(
    fontSize: 16,
  ));
  UserModel user;

  @override
  void initState() {
    findUserModel();
    super.initState();
  }

  Future<void> findUserModel() async {
    int count1 = 0, count2 = 0;
    UserModel userModel = await UserHelper().getUserInfo(context);
    EnrolledCourseModel enrolledCourseModel =
        await CourseHelper().getMyCourses(context: context);
    List<EnrolledCourse> enrolledCourses = enrolledCourseModel.results;

    if (enrolledCourses != null) {
      for (int i = 0; i < enrolledCourses.length; i++) {
        enrolledCourses[i].isPremium ? count1++ : count2++;
      }
    }
    if (mounted) {
      Provider.of<ProfileProvider>(context, listen: false)
          .setUserProfile(userModel);
      Provider.of<ProfileProvider>(context, listen: false)
          .setProfileImage(userModel.image);
      Provider.of<ProfileProvider>(context, listen: false)
          .setmyCourses(count1, count2);
      Provider.of<ProfileProvider>(context, listen: false).setProfileStatus();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
        builder: ((context, profile, child) => SafeArea(
              child: Scaffold(
                body: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profile.isProfileUpdated
                            ? Expanded(
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  // mainAxisAlignment: MainAxisAlignment.center,s
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    ProfileWidget(
                                      imagePath: profile.getProfileImage(),
                                      onClicked: () {
                                        Navigator.of(context).push(
                                            CustomPageRoute(
                                                child: EditProfilePage(
                                                  userModel: profile.userModel,
                                                ),
                                                direction:
                                                    AxisDirection.right));
                                      },
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    buildName(profile.userModel),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    Center(child: buildPurchaseButton()),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    NumbersWidget(profile.getFreeCount(),
                                        profile.getpremiumCount()),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    buildEducation(profile.userModel),
                                  ],
                                ),
                              )
                            : buildProfileShimmer()
                      ],
                    ),
                  ),
                  Positioned(
                    child: new IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    top: 0,
                    left: 0,
                  ),
                ]),
              ),
            )));
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Text(user.name,
              style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ))),
          SizedBox(
            height: 5,
          ),
          Text(
            user.email,
            style: GoogleFonts.ubuntu(textStyle: TextStyle()),
          )
        ],
      );

  Widget buildPurchaseButton() => Container(
        height: 60,
        width: 200,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.white)))),
          child: Text(
            "Purchase Course",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      );

  Widget buildEducation(UserModel user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Education",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 16,
            ),
            Text("Institue",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ))),
            Text(user.institute != null ? user.institute : "N/A",
                style: smallTxStyle),
            SizedBox(
              height: 20,
            ),
            Text("Study Level",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ))),
            Text(user.level != null ? user.level : "N/A", style: smallTxStyle),
            SizedBox(
              height: 20,
            ),
            Text("Course Name",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ))),
            Text(user.courseName != null ? user.courseName : "N/A",
                style: smallTxStyle),
            SizedBox(
              height: 30,
            ),
            Text("Personal Info",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 16,
            ),
            Text("Date of Birth",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ))),
            Text(user.dob != null ? user.dob : "N/A", style: smallTxStyle),
            SizedBox(
              height: 20,
            ),
            Text("Home Address",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ))),
            Text(user.address != null ? user.address : "N/A",
                style: smallTxStyle),
            SizedBox(
              height: 20,
            ),
            Text("Phone Number",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ))),
            Text(
                (user.phoneNumber != null && user.phoneNumber.isNotEmpty)
                    ? user.phoneNumber
                    : "N/A",
                style: smallTxStyle),
          ],
        ),
      );

  Widget buildProfileShimmer() {
    return Container(
      child: Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 30,
            ),

            Column(
              children: [
                //Profile
                ShimmerWidget.rectangular(
                  height: 128,
                  isCicular: true,
                  width: 128,
                ),
                SizedBox(
                  height: 24,
                ),
                // name and email
                ShimmerWidget.rectangular(
                  height: 16,
                  width: 150,
                ),
                SizedBox(
                  height: 10,
                ),
                ShimmerWidget.rectangular(
                  height: 10,
                  width: 200,
                ),
                SizedBox(
                  height: 40,
                ),
                //purchase button
                ShimmerWidget.rectangular(
                  height: 30,
                  width: 150,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
            //build numbers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ShimmerWidget.rectangular(
                      height: 16,
                      width: 100,
                    )
                  ],
                ),
                Container(height: 24, child: VerticalDivider()),
                Column(
                  children: [
                    ShimmerWidget.rectangular(
                      height: 16,
                      width: 100,
                    )
                  ],
                ),
                Container(height: 24, child: VerticalDivider()),
                Column(
                  children: [
                    ShimmerWidget.rectangular(
                      height: 16,
                      width: 100,
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //buildEducation
                  for (int i = 0; i < 3; i++) _buildInfoShimmer()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        ShimmerWidget.rectangular(
          height: 16,
          width: 130,
        ),
        for (int i = 0; i < 3; i++) _buildInfoChildShimmer(),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _buildInfoChildShimmer() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        ShimmerWidget.rectangular(
          height: 10,
          width: 100,
        ),
        SizedBox(height: 5),
        ShimmerWidget.rectangular(
          height: 5,
          width: 100,
        ),
      ],
    );
  }
}
