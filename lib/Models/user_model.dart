// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class UserModel {
  UserModel({
    @required this.id,
    @required this.username,
    @required this.name,
    @required this.email,
    @required this.phoneNumber,
    @required this.image,
    @required this.dob,
    @required this.institute,
    @required this.address,
    @required this.level,
    @required this.courseName,
  });

  final int id;
  final String username;
  String name;
  String email;
  String phoneNumber;
  String image;
  dynamic dob;
  dynamic institute;
  dynamic address;
  dynamic level;
  dynamic courseName;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        image: json["image"],
        dob: json["dob"],
        institute: json["institute"],
        address: json["address"],
        level: json["level"],
        courseName: json["course_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "image": image,
        "dob": dob,
        "institute": institute,
        "address": address,
        "level": level,
        "course_name": courseName,
      };
}
