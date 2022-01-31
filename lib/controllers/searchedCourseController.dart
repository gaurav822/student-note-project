import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/search_course_model.dart';
import 'package:student_notes/Widgets/searchcoursecard.dart';

class SearchedCourseController extends GetxController {
  String query;
  SearchedCourseController({@required this.query}) {
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
    SearchCourseModel courseList =
        await CourseHelper.searchCourse(searchQuery: query);

    List<Widget> _tempList = [];
    if (courseList.results != null) {
      for (var eachCourse in courseList.results) {
        _tempList.add(SearchCard(eachCourse));
      }
      _courseList = _tempList;
      update();
    } else {
      _tempList = [Text("No data found")];
      _courseList = _tempList;
      update();
    }
  }
}
