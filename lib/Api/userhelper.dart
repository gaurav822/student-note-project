import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
// ignore: implementation_imports
import 'package:dio/src/form_data.dart' as fd;
import 'package:provider/provider.dart';
import 'package:student_notes/Models/user_model.dart';
import 'package:path/path.dart';

import '../provider/profileprovider.dart';

class UserHelper {
  static final String url = dotenv.get('API_URL');

  UserHelper() {
    //
  }

  Future<String> updateProfilePicture(filePath, BuildContext context) async {
    String fileName = basename(filePath.path);
    UserModel userModel = await UserHelper().getUserInfo(context);
    try {
      fd.FormData formData = fd.FormData.fromMap({
        "image": await MultipartFile.fromFile(filePath.path, filename: fileName)
      });

      Dio dio = new Dio(
          BaseOptions(headers: _setHeadersForProfile(context: context)));

      Response response = await dio.patch(
        '$url/auth/update_profile/${userModel.id}/',
        data: formData,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> userInfo = response.data;
        String imageUrl = userInfo["image"];
        return imageUrl;
      } else {
        print("The Error from catch here");
        return "404";
      }
    } catch (e) {
      print("Error from catch here");
      return "404";
    }
  }

  Future<String> updateUserInfo(
      {String fullName,
      String phoneNumber,
      String dateOfBirth,
      String institute,
      String address,
      String coursename,
      String studylevel,
      BuildContext context}) async {
    UserModel userModel = await UserHelper().getUserInfo(context);

    try {
      var response = await http.patch(
          Uri.parse('$url/auth/update_profile/${userModel.id}/'),
          body: <String, String>{
            "name": fullName,
            "phone_number": phoneNumber,
            "dob": dateOfBirth,
            "institute": institute,
            "course_name": coursename,
            "level": studylevel,
            "address": address,
          },
          headers: _setHeadersforUpdate(context: context));

      print("This is response" + response.toString());

      return response.statusCode.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserModel> getUserInfo(BuildContext context) async {
    try {
      var response = await http.get(Uri.parse('$url/auth/userinfo/'),
          headers: _setHeadersForProfile(context: context));

      Map<String, dynamic> data = jsonDecode(response.body);

      List userList = data["data"];
      Map<String, dynamic> userInfo = userList[0];

      UserModel userModel = UserModel(
          id: userInfo["id"],
          username: userInfo["username"],
          name: userInfo["name"],
          email: userInfo["email"],
          phoneNumber: userInfo["phone_number"],
          image: userInfo["image"],
          dob: userInfo["dob"],
          institute: userInfo["institute"],
          address: userInfo["address"],
          level: userInfo["level"],
          courseName: userInfo["course_name"]);

      return userModel;
    } catch (e) {
      return null;
    }
  }

  _setHeadersforUpdate({BuildContext context}) => {
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${Provider.of<ProfileProvider>(context, listen: false).getAccessToken()}'
      };

  _setHeadersForProfile({BuildContext context}) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${Provider.of<ProfileProvider>(context, listen: false).getAccessToken()}'
      };
}
