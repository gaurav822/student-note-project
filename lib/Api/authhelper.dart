import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// ignore: implementation_imports
import 'package:dio/src/form_data.dart' as fd;
import 'package:provider/provider.dart';
import 'package:student_notes/Api/userhelper.dart';
import 'package:student_notes/Models/user_model.dart';
import 'package:student_notes/Screens/Authscreens/loginUI.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';

import '../provider/profileprovider.dart';

class AuthHelper {
  static final String url = "https://api.iscmentor.com";

  AuthHelper() {
    //
  }

  static Future<String> login(String email, String password) async {
    Map data = {"username": email, "password": password};

    try {
      var res = await http.post(Uri.parse('$url/auth/login/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      if (res.statusCode == 200) {
        Map<String, dynamic> responsedata = jsonDecode(res.body);
        Map<String, dynamic> token = responsedata["tokens"];
        String uname = responsedata["username"];
        String email = responsedata["email"];
        String accesstoken = token["access"];
        String refreshtoken = token["refresh"];
        await SecuredStorage.setUserDetails(
            username: uname,
            email: email,
            access: accesstoken,
            refresh: refreshtoken);
        return res.body;
      } else if (res.statusCode == 401) {
        return "401";
        //invalid credentials
      } else {
        return "400";
        //email not verified
      }
    } on SocketException catch (e) {
      print(e.toString());
      return "404";
      //socket or internet errors
    } catch (e) {
      return "404";
    }
  }

  static Future<String> createUser(String uname, String name, String email,
      String pnumber, String password) async {
    fd.FormData formData = fd.FormData.fromMap({
      "username": uname,
      "name": name,
      "email": email,
      "phone_number": pnumber,
      "password": password
    });

    Dio dio = new Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    ));

    try {
      var res = await dio.post("$url/auth/register/",
          data: formData,
          options: Options(
            headers: {"accept": "*/*", "Content-Type": "multipart/form-data"},
          ));

      if (res.statusCode == 201) {
        return "201";
      } else
        return res.data.toString();
    } on SocketException catch (e) {
      print(e);
      return "404";
    } catch (e) {
      print(e.toString());
      return "404";
    }
  }

  Future<String> logout(BuildContext context) async {
    try {
      var response = await http.post(Uri.parse('$url/auth/logout/'),
          headers: _setHeadersForAuth(context: context),
          body: jsonEncode(<String, String>{
            'refresh': Provider.of<ProfileProvider>(context, listen: false)
                .getRefreshToken()
          }));

      return response.statusCode.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> changePassword(
      String oldpass, String pass1, String pass2, BuildContext context) async {
    UserModel userModel = await UserHelper().getUserInfo(context);

    try {
      var res = await http.patch(
          Uri.parse('$url/auth/change_password/${userModel.id}/'),
          headers: _setHeadersForAuth(context: context),
          body: jsonEncode(<String, String>{
            'old_password': oldpass,
            'password': pass1,
            'password2': pass2,
          }));
      if (res.statusCode == 200) {
        return "200";
      } else {
        return res.body.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> sendResetPasswordEmail(String email) async {
    Map data = {"email": email};

    try {
      var response = await http.post(
        Uri.parse('$url/auth/request-reset-email/'),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return "200";
      } else {
        return "404";
      }
    } on SocketException catch (e) {
      print(e);
      return "400";
    } catch (e) {
      return "400";
    }
  }

  static Future<String> updateAccessToken() async {
    String refresh = await SecuredStorage.getRefresh();
    String access = await SecuredStorage.getAccess();

    if (access != null) {
      try {
        var res = await http.post(
            Uri.parse('https://api.iscmentor.com/auth/token/refresh/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'refresh': refresh}));

        if (res.statusCode == 200) {
          Map<String, dynamic> responsedata = jsonDecode(res.body);
          String newAccessToken = responsedata["access"];
          await SecuredStorage.setAccess(newAccessToken);
          return newAccessToken;
        } else {
          Get.offAll(LoginScreen());
          return "400";
        }
      } on SocketException catch (e) {
        print(e.toString());
        return "401";
      } catch (e) {
        print("The catch is from here" + e.toString());
        return "401";
      }
    } else {
      return "400";
    }
  }

  static Future<String> googleSignIn(
      {String authToken, BuildContext context}) async {
    Map data = {"auth_token": authToken};

    try {
      var response = await http.post(
        Uri.parse('$url/social_auth/google/'),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responsedata = jsonDecode(response.body);
        Map<String, dynamic> token = responsedata["tokens"];
        String uname = responsedata["username"];
        String email = responsedata["email"];
        String accesstoken = token["access"];
        String refreshtoken = token["refresh"];
        await SecuredStorage.setUserDetails(
            username: uname,
            email: email,
            access: accesstoken,
            refresh: refreshtoken);
        Provider.of<ProfileProvider>(context, listen: false).tokenSet(
            access: accesstoken,
            refresh: refreshtoken,
            email: email,
            username: uname);

        return "200";
      } else {
        return "404";
      }
    } catch (e) {
      print(e.toString());
      return "404";
    }
  }

  static Future<String> resetPasswordViaEmail(
      String password, String uidb64, String token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      var res =
          await http.patch(Uri.parse('$url/auth/password-reset-complete/'),
              body: jsonEncode(<String, String>{
                'password': password,
                'uidb64': uidb64,
                'token': token,
              }),
              headers: requestHeaders);
      print("The response for pass reset " + res.body);
      if (res.statusCode == 200) {
        return "200";
      } else {
        return res.body.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  _setHeadersForAuth({BuildContext context}) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${Provider.of<ProfileProvider>(context, listen: false).getAccessToken()}'
      };
}
