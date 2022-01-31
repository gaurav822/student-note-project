// To parse this JSON data, do
//
//     final searchCourseModel = searchCourseModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class SearchCourseModel {
  SearchCourseModel({
    @required this.count,
    @required this.next,
    @required this.previous,
    @required this.results,
  });

  final int count;
  final dynamic next;
  final dynamic previous;
  final List<SearchCourse> results;

  factory SearchCourseModel.fromJson(String str) =>
      SearchCourseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchCourseModel.fromMap(Map<String, dynamic> json) =>
      SearchCourseModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<SearchCourse>.from(
            json["results"].map((x) => SearchCourse.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class SearchCourse {
  SearchCourse({
    @required this.courseId,
    @required this.courseName,
    @required this.courseSlug,
    @required this.chapterId,
    @required this.chapterTitle,
    @required this.quesId,
    @required this.question,
  });

  final int courseId;
  final String courseName;
  final String courseSlug;
  final int chapterId;
  final String chapterTitle;
  final int quesId;
  final String question;

  factory SearchCourse.fromJson(String str) =>
      SearchCourse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchCourse.fromMap(Map<String, dynamic> json) => SearchCourse(
        courseId: json["course_id"],
        courseName: json["course_name"],
        courseSlug: json["course_slug"],
        chapterId: json["chapter_id"],
        chapterTitle: json["chapter_title"],
        quesId: json["ques_id"],
        question: json["question"],
      );

  Map<String, dynamic> toMap() => {
        "course_id": courseId,
        "course_name": courseName,
        "course_slug": courseSlug,
        "chapter_id": chapterId,
        "chapter_title": chapterTitle,
        "ques_id": quesId,
        "question": question,
      };
}
