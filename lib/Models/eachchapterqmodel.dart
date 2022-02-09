// To parse this JSON data, do
//
//     final eachChapterQModel = eachChapterQModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class EachChapterQModel {
  EachChapterQModel({
    @required this.count,
    @required this.next,
    @required this.previous,
    @required this.results,
  });

  final int count;
  final dynamic next;
  final dynamic previous;
  final List<Result> results;

  factory EachChapterQModel.fromJson(String str) =>
      EachChapterQModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EachChapterQModel.fromMap(Map<String, dynamic> json) =>
      EachChapterQModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class Result {
  Result({
    @required this.courseId,
    @required this.courseName,
    @required this.isPremium,
    @required this.id,
    @required this.chapterTitle,
    @required this.questions,
  });

  final int courseId;
  final String courseName;
  final bool isPremium;
  final int id;
  final String chapterTitle;
  final List<Question> questions;

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        courseId: json["course_id"],
        courseName: json["course_name"],
        isPremium: json["is_premium"],
        id: json["id"],
        chapterTitle: json["chapter_title"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "course_id": courseId,
        "course_name": courseName,
        "is_premium": isPremium,
        "id": id,
        "chapter_title": chapterTitle,
        "questions": List<dynamic>.from(questions.map((x) => x.toMap())),
      };
}

class Question {
  Question(
      {@required this.id,
      @required this.question,
      @required this.answer,
      @required this.canView,
      @required this.course,
      @required this.chapter,
      this.isExpanded = false});

  final int id;
  final String question;
  final String answer;
  final bool canView;
  final int course;
  final int chapter;
  bool isExpanded;

  factory Question.fromJson(String str) => Question.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Question.fromMap(Map<String, dynamic> json) => Question(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        canView: json["can_view"],
        course: json["course"],
        chapter: json["chapter"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "question": question,
        "answer": answer,
        "can_view": canView,
        "course": course,
        "chapter": chapter,
      };
}
