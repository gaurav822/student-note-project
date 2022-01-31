import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_content_model.dart';
import 'package:student_notes/Widgets/chaptercard.dart';

class CourseContentController extends GetxController {
  CourseContentController({String slugName}) {
    _getchapterList(slugName);
  }

  List<Widget> _chapterList = [
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Center(child: CircularProgressIndicator())],
    )
  ];
  List<Widget> get chapterList => _chapterList;

  _getchapterList(String slugName) async {
    CourseContents courseContents =
        await CourseHelper.getCourseContents(slugName);

    List<Widget> _tempList = [];

    print("The chapters are :" + courseContents.chapters.toString());

    for (var eachChapter in courseContents.chapters) {
      _tempList.add(ChapterCard(eachChapter));
    }
    _chapterList = _tempList;

    update();
  }
}
