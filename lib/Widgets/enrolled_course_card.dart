import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Screens/coursecontent/course_content.dart';
import 'package:student_notes/Widgets/custom_page_route.dart';

class EnrolledCourseCard extends StatelessWidget {
  final EnrolledCourse enrolledCourse;
  EnrolledCourseCard(this.enrolledCourse);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(enrolledCourse.image !=
                          "https://api.iscmentor.com/media/course_img/default.jpg"
                      ? enrolledCourse.image
                      : "https://www.publicdomainpictures.net/pictures/30000/velka/plain-white-background.jpg")),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(spreadRadius: .5, color: Colors.white)]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                enrolledCourse.paid || !enrolledCourse.isPremium
                    ? Navigator.of(context).push(CustomPageRoute(
                        child: CourseContent(enrolledCourse),
                        direction: AxisDirection.right))
                    : Fluttertoast.showToast(
                        msg: "Payment not verified !",
                        backgroundColor: Colors.red.shade400);
              },
              child: Column(
                children: [
                  Text(
                    enrolledCourse.courseName,
                    style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    enrolledCourse.description,
                    style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  enrolledCourse.paid || !enrolledCourse.isPremium
                      ? Text(
                          "Click to view contents",
                          style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20)),
                        )
                      : SizedBox(),
                  Spacer(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        enrolledCourse.isPremium
                            ? Row(
                                children: [
                                  Text(
                                    "Payment status : ",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  Text(
                                    enrolledCourse.paid ? "Paid" : "Pending",
                                    style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        color: enrolledCourse.paid
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(),
                        (!enrolledCourse.isPremium || !enrolledCourse.paid)
                            ? IconButton(
                                tooltip: "Delete",
                                onPressed: () {
                                  _unEnrollFromCourse(
                                      enrolledCourse.slug, context);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                            : SizedBox(),
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _unEnrollFromCourse(String slug, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Deleting course..."),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        });
    String res = await CourseHelper.unenrollCourse(slug);
    if (res == "200") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "you are unenrolled from this course",
          backgroundColor: Colors.green,
          fontSize: 16,
          toastLength: Toast.LENGTH_LONG);
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Problem deleting the course",
          backgroundColor: Colors.red,
          fontSize: 16,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
