import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Widgets/enrolled_course_card.dart';

class MyCourse extends StatefulWidget {
  const MyCourse({Key key}) : super(key: key);

  @override
  _MyCourseState createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> {
  StreamController<EnrolledCourseModel> _enrolledCourseStream =
      StreamController();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(Duration(seconds: 3), (timer) {
      getEnrolledCourses();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _enrolledCourseStream.close();
  }

  Future<void> getEnrolledCourses() async {
    EnrolledCourseModel enrolledCourseModel = await CourseHelper.getMyCourses();

    if (!_enrolledCourseStream.isClosed) {
      _enrolledCourseStream.sink.add(enrolledCourseModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<EnrolledCourseModel>(
            stream: _enrolledCourseStream.stream,
            builder: (context, snapdata) {
              switch (snapdata.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                default:
                  if (snapdata.hasError) {
                    return Center(child: Text("Error Loading Data"));
                  }
                  if (snapdata.data.results.isBlank) {
                    return Center(
                        child: Text("you are not enrolled in any courses",
                            style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))));
                  } else {
                    return Container(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapdata.data.results.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: EnrolledCourseCard(
                                  snapdata.data.results[index]),
                            );
                          }),
                    );
                  }
              }
            }));
  }
}
