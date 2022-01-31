// To parse this JSON data, do
//
//     final courseList = courseListFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class CourseList {
  CourseList({
    @required this.count,
    @required this.next,
    @required this.previous,
    @required this.results,
  });

  final int count;
  final dynamic next;
  final dynamic previous;
  final List<Course> results;

  factory CourseList.fromJson(String str) =>
      CourseList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CourseList.fromMap(Map<String, dynamic> json) => CourseList(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Course>.from(json["results"].map((x) => Course.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class Course {
  Course({
    @required this.courseName,
    @required this.image,
    @required this.grade,
    @required this.slug,
    @required this.description,
    @required this.originalFee,
    @required this.discount,
    @required this.isPremium,
  });

  final String courseName;
  final String image;
  final String grade;
  final String slug;
  final String description;
  final double originalFee;
  final double discount;
  final bool isPremium;

  factory Course.fromJson(String str) => Course.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Course.fromMap(Map<String, dynamic> json) => Course(
        courseName: json["course_name"],
        image: json["image"],
        grade: json["grade"],
        slug: json["slug"],
        description: json["description"],
        originalFee: json["original_fee"],
        discount: json["discount"],
        isPremium: json["is_premium"],
      );

  Map<String, dynamic> toMap() => {
        "course_name": courseName,
        "image": image,
        "grade": grade,
        "slug": slug,
        "description": description,
        "original_fee": originalFee,
        "discount": discount,
        "is_premium": isPremium,
      };
}
