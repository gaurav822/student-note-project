import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_model.dart';
import 'package:student_notes/Screens/buyscreen/buyscreen.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';
import 'package:student_notes/Widgets/custom_page_route.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  CourseCard(this.course);
  @override
  Widget build(BuildContext context) {
    double finalPrice =
        course.originalFee - course.originalFee * (course.discount / 100);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: Get.width * .7,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(spreadRadius: .5, color: Colors.white)]),
        child: Column(
          children: [
            Text(
              course.courseName,
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            AutoSizeText(
              course.description,
              maxLines: 2,
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                  fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                course.isPremium ? "Rs. " + finalPrice.toInt().toString() : "",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(width: 5),
              RichText(
                text: new TextSpan(children: [
                  TextSpan(
                      text: course.isPremium
                          ? 'Rs. ' + course.originalFee.toInt().toString()
                          : "",
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough))
                ]),
              )
            ]),
            Text(
              course.isPremium
                  ? course.discount.toInt().toString() + "% off "
                  : "",
              style: TextStyle(
                  color: Color(0xff9C4040),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            course.isPremium ? SizedBox(height: 20) : SizedBox(),
            course.isPremium
                ? Container(
                    width: Get.width * .5,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // <-- Radius
                            ),
                            primary: Color(0xfff06315c)),
                        onPressed: () {
                          Navigator.of(context).push(CustomPageRoute(
                              child: BuyScreen(
                                course: course,
                              ),
                              direction: AxisDirection.right));
                        },
                        child: Text(
                          "Buy Now",
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        )))
                : Container(
                    child: Text(
                      "Free Content",
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black)),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            !course.isPremium
                ? Container(
                    width: 100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                            primary: Color(0xfff06315c)),
                        onPressed: () {
                          _enrollIntoFreeCourse(context);
                        },
                        child: Text(
                          "Enroll",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  _enrollIntoFreeCourse(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: LoadingDialog(
              loadText: "Request for Enrollment...",
            ),
          );
        });

    String res = await CourseHelper.enrollCourse(course.slug);

    if (res == "201") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Enrolled Successfully !",
          backgroundColor: Colors.green,
          fontSize: 16,
          toastLength: Toast.LENGTH_LONG);
    } else if (res == "400") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Already Enrolled in this Course",
          backgroundColor: Colors.red,
          fontSize: 16,
          toastLength: Toast.LENGTH_LONG);
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Error Enrolling",
        backgroundColor: Colors.red,
        fontSize: 16,
      );
    }
  }
}
