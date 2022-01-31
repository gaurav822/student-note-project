// To parse this JSON data, do
//
//     final adModel = adModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class AdModel {
  AdModel({
    @required this.count,
    @required this.next,
    @required this.previous,
    @required this.results,
  });

  final int count;
  final dynamic next;
  final dynamic previous;
  final List<Advertise> results;

  factory AdModel.fromJson(String str) => AdModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdModel.fromMap(Map<String, dynamic> json) => AdModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Advertise>.from(
            json["results"].map((x) => Advertise.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class Advertise {
  Advertise({
    @required this.title,
    @required this.image,
    @required this.priority,
    @required this.createdAt,
  });

  final String title;
  final String image;
  final String priority;
  final DateTime createdAt;

  factory Advertise.fromJson(String str) => Advertise.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Advertise.fromMap(Map<String, dynamic> json) => Advertise(
        title: json["title"],
        image: json["image"],
        priority: json["priority"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "image": image,
        "priority": priority,
        "created_at": createdAt.toIso8601String(),
      };
}
