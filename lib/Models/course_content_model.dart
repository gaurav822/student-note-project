// To parse this JSON data, do
//
//     final courseContents = courseContentsFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class CourseContents {
  CourseContents({
    @required this.id,
    @required this.chapters,
    @required this.courseName,
    @required this.slug,
    @required this.grade,
    @required this.description,
    @required this.originalFee,
    @required this.discount,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.isPremium,
    @required this.status,
    @required this.author,
  });

  final int id;
  final List<Chapter> chapters;
  final String courseName;
  final String slug;
  final String grade;
  final String description;
  final double originalFee;
  final double discount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPremium;
  final String status;
  final int author;

  factory CourseContents.fromJson(String str) =>
      CourseContents.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CourseContents.fromMap(Map<String, dynamic> json) => CourseContents(
        id: json["id"],
        chapters:
            List<Chapter>.from(json["chapters"].map((x) => Chapter.fromMap(x))),
        courseName: json["course_name"],
        slug: json["slug"],
        grade: json["grade"],
        description: json["description"],
        originalFee: json["original_fee"],
        discount: json["discount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isPremium: json["is_premium"],
        status: json["status"],
        author: json["author"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "chapters": List<dynamic>.from(chapters.map((x) => x.toMap())),
        "course_name": courseName,
        "slug": slug,
        "grade": grade,
        "description": description,
        "original_fee": originalFee,
        "discount": discount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_premium": isPremium,
        "status": status,
        "author": author,
      };
}

class Chapter {
  Chapter({
    @required this.id,
    @required this.questions,
    @required this.chapterTitle,
    @required this.course,
  });

  final int id;
  final List<dynamic> questions;
  final String chapterTitle;
  final int course;

  factory Chapter.fromJson(String str) => Chapter.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Chapter.fromMap(Map<String, dynamic> json) => Chapter(
        id: json["id"],
        questions: List<dynamic>.from(json["questions"].map((x) => x)),
        chapterTitle: json["chapter_title"],
        course: json["course"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "questions": List<dynamic>.from(questions.map((x) => x)),
        "chapter_title": chapterTitle,
        "course": course,
      };
}
