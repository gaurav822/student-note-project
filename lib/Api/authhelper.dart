import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
// ignore: implementation_imports
import 'package:dio/src/form_data.dart' as fd;
import 'package:student_notes/Api/userhelper.dart';
import 'package:student_notes/Models/user_model.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';

class AuthHelper {
  // static final String url = dotenv.get('API_URL');

  static final String url = "https://api.iscmentor.com";

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

        await SecuredStorage.setUsername(uname);
        await SecuredStorage.setEmail(email);
        await SecuredStorage.setAccess(accesstoken);
        await SecuredStorage.setRefresh(refreshtoken);
      }
      return res.statusCode.toString();
    } on SocketException catch (e) {
      print(e);
      return "404";
    } catch (e) {
      return e.toString();
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

  static Future<String> logout() async {
    // await SecuredStorage.clear();
    String access = await SecuredStorage.getAccess();
    String refresh = await SecuredStorage.getRefresh();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access,
    };

    try {
      var response = await http.post(Uri.parse('$url/auth/logout/'),
          headers: requestHeaders,
          body: jsonEncode(<String, String>{'refresh': refresh}));

      print("This is response for logout " + response.body);
      return response.statusCode.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> changePassword(
      String oldpass, String pass1, String pass2) async {
    String access = await SecuredStorage.getAccess();
    UserModel userModel = await UserHelper.getUserInfo();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access,
    };

    try {
      var res = await http.patch(
          Uri.parse('$url/auth/change_password/${userModel.id}/'),
          headers: requestHeaders,
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
    String email = await SecuredStorage.getEmail();

    if (email != null) {
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
          return "200";
        } else {
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

  static Future<String> googleSignIn({String authToken}) async {
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
        await SecuredStorage.setUsername(uname);
        await SecuredStorage.setEmail(email);
        await SecuredStorage.setAccess(accesstoken);
        await SecuredStorage.setRefresh(refreshtoken);
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
}
