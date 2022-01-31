import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
// ignore: implementation_imports
import 'package:dio/src/form_data.dart' as fd;
import 'package:student_notes/Models/user_model.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';
import 'package:path/path.dart';

class UserHelper {
  static final String url = dotenv.get('API_URL');

  static Future<String> updateProfilePicture(filePath) async {
    String fileName = basename(filePath.path);
    UserModel userModel = await UserHelper.getUserInfo();
    String access = await SecuredStorage.getAccess();
    try {
      fd.FormData formData = fd.FormData.fromMap({
        "image": await MultipartFile.fromFile(filePath.path, filename: fileName)
      });

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + access
      };

      Dio dio = new Dio(BaseOptions(headers: requestHeaders));

      Response response = await dio.patch(
        '$url/auth/update_profile/${userModel.id}/',
        data: formData,
      );

      return response.statusCode.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> updateUserInfo(
      {String fullName,
      String phoneNumber,
      String dateOfBirth,
      String institute,
      String address,
      String coursename,
      String studylevel}) async {
    UserModel userModel = await UserHelper.getUserInfo();

    String access = await SecuredStorage.getAccess();

    try {
      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + access
      };

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
          headers: requestHeaders);

      print("This is response" + response.toString());

      return response.statusCode.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<UserModel> getUserInfo() async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access
    };

    try {
      var response = await http.get(Uri.parse('$url/auth/userinfo/'),
          headers: requestHeaders);

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
}
