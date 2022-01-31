import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_model.dart';
import 'package:student_notes/Widgets/courseCard.dart';

class CourseController extends GetxController {
  String query = '';
  CourseController() {
    _getCoursesList();
  }

  onChanged(String val) {
    query = val;
    print(query);
    update();
  }

  List<Widget> _courseList = [
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Center(child: CircularProgressIndicator())],
    )
  ];
  List<Widget> get courseList => _courseList;

  _getCoursesList() async {
    CourseList courseList = await CourseHelper.listCourses();

    List<Widget> _tempList = [];

    if (courseList != null) {
      for (var eachCourse in courseList.results) {
        _tempList.add(CourseCard(eachCourse));
      }
      _courseList = _tempList;
    } else {
      _courseList = [Text("Courses are not available")];
    }

    update();
  }
}
