import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Widgets/enrolled_course_card.dart';

class EnrolledCourseController extends GetxController {
  EnrolledCourseController() {
    _getCoursesList();
  }

  List<Widget> _courseList = [
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Center(child: CircularProgressIndicator())],
    )
  ];
  List<Widget> get courseList => _courseList;

  _getCoursesList() async {
    EnrolledCourseModel courseList = await CourseHelper.getMyCourses();
    List<Widget> _tempList = [];
    if (courseList != null) {
      for (var eachCourse in courseList.results) {
        _tempList.add(EnrolledCourseCard(eachCourse));
      }
    }
    _courseList = _tempList;
    update();
  }
}
