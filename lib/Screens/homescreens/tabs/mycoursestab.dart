import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/cards/enrolled_course_card.dart';
import 'package:student_notes/provider/enrolledcoursesprovider.dart';

class MyCourse extends StatefulWidget {
  const MyCourse({Key key}) : super(key: key);

  @override
  _MyCourseState createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    getEnrolledCourses();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getEnrolledCourses() async {
    _isLoading = true;
    EnrolledCourseModel enrolledCourseModel =
        await CourseHelper().getMyCourses(context: context);
    List<EnrolledCourse> mycourse = enrolledCourseModel.results;

    if (mounted) {
      Provider.of<EnrolledCourseProvider>(context, listen: false)
          .setMyCourses(mycourse);
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EnrolledCourseProvider>(
        builder: (context, enrolledcourse, child) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : enrolledcourse.enrolledCourses.isEmpty
                ? Center(
                    child: Text(
                      "You are not enrolled to any courses",
                      style: GoogleFonts.ubuntu(
                          textStyle:
                              TextStyle(fontSize: 18, color: Colors.red)),
                    ),
                  )
                : Container(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        getEnrolledCourses();
                        setState(() {});
                        return true;
                      },
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: enrolledcourse.enrolledCourses.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: EnrolledCourseCard(
                                  enrolledcourse.enrolledCourses[
                                      enrolledcourse.enrolledCourses.length -
                                          (index + 1)]),
                            );
                          }),
                    ),
                  ));
  }
}
