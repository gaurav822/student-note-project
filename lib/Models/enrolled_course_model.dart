// To parse this JSON data, do
//
//     final enrolledCourseModel = enrolledCourseModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class EnrolledCourseModel {
  EnrolledCourseModel({
    @required this.count,
    @required this.next,
    @required this.previous,
    @required this.results,
  });

  final int count;
  final dynamic next;
  final dynamic previous;
  final List<EnrolledCourse> results;

  factory EnrolledCourseModel.fromJson(String str) =>
      EnrolledCourseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EnrolledCourseModel.fromMap(Map<String, dynamic> json) =>
      EnrolledCourseModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<EnrolledCourse>.from(
            json["results"].map((x) => EnrolledCourse.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class EnrolledCourse {
  EnrolledCourse({
    @required this.courseName,
    @required this.image,
    @required this.grade,
    @required this.slug,
    @required this.isPremium,
    @required this.description,
    @required this.enrolledAt,
    @required this.paid,
  });

  final String courseName;
  final String image;
  final String grade;
  final String slug;
  final bool isPremium;
  final String description;
  final DateTime enrolledAt;
  final bool paid;

  factory EnrolledCourse.fromJson(String str) =>
      EnrolledCourse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EnrolledCourse.fromMap(Map<String, dynamic> json) => EnrolledCourse(
        courseName: json["course_name"],
        image: json["image"],
        grade: json["grade"],
        slug: json["slug"],
        isPremium: json["is_premium"],
        description: json["description"],
        enrolledAt: DateTime.parse(json["enrolled_at"]),
        paid: json["paid"],
      );

  Map<String, dynamic> toMap() => {
        "course_name": courseName,
        "image": image,
        "grade": grade,
        "slug": slug,
        "is_premium": isPremium,
        "description": description,
        "enrolled_at": enrolledAt.toIso8601String(),
        "paid": paid,
      };
}
