// To parse this JSON data, do
//
//     final questionDetailModel = questionDetailModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class QuestionDetailModel {
  QuestionDetailModel({
    @required this.id,
    @required this.question,
    @required this.answer,
    @required this.canView,
    @required this.course,
    @required this.chapter,
  });

  final int id;
  final String question;
  final String answer;
  final bool canView;
  final int course;
  final int chapter;

  factory QuestionDetailModel.fromJson(String str) =>
      QuestionDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuestionDetailModel.fromMap(Map<String, dynamic> json) =>
      QuestionDetailModel(
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
