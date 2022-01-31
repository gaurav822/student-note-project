import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:student_notes/Models/course_content_model.dart';
import 'package:student_notes/Models/course_model.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Models/search_course_model.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';

class CourseHelper {
  static final String url = dotenv.get('API_URL');

  static Future<String> enrollCourse(String slug) async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access,
    };

    Map data = {"slug": slug};

    try {
      var response = await http.post(Uri.parse('$url/course/enroll/'),
          headers: requestHeaders, body: jsonEncode(data));
      if (response.statusCode == 201) {
        return "201";
        //success
      } else if (response.statusCode == 401) {
        return "401";
        //bad authorization
      } else if (response.statusCode == 400) {
        return "400";
        //already enrolled
      } else {
        return "404";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> unenrollCourse(String slug) async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access,
    };

    Map data = {"slug": slug};

    try {
      var response = await http.post(Uri.parse('$url/course/unenroll/'),
          headers: requestHeaders, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return "200";
        //success
      } else {
        //failed
        return "404";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<EnrolledCourseModel> getMyCourses() async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access,
    };

    try {
      var response = await http.get(Uri.parse('$url/course/mycourse/'),
          headers: requestHeaders);
      if (response.statusCode == 200) {
        return EnrolledCourseModel.fromJson(response.body);
      } else {
        return EnrolledCourseModel(count: 0, next: 0, previous: 0, results: []);
      }
    } catch (e) {
      return EnrolledCourseModel(count: 0, next: 0, previous: 0, results: []);
    }
  }

  static Future<CourseList> listCourses(
      {bool sortByPopular = false, bool sortByNew = false}) async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access
    };

    String finalUrl = sortByPopular
        ? url + '/course/popular-course/'
        : sortByNew
            ? url + '/course/new-course/'
            : url + '/course/all/';

    try {
      var response =
          await http.get(Uri.parse(finalUrl), headers: requestHeaders);

      return CourseList.fromJson(response.body);
    } catch (e) {
      print(e.toString());
      return CourseList(count: 0, next: 0, previous: 0, results: []);
    }
  }

  static Future<CourseContents> getCourseContents(String slugName) async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access,
    };

    try {
      var response = await http.get(Uri.parse('$url/course/content/$slugName/'),
          headers: requestHeaders);
      if (response.statusCode == 200) {
        print(response.body);
        return CourseContents.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<SearchCourseModel> searchCourse({String searchQuery}) async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access,
    };

    try {
      var response = await http.get(
          Uri.parse('$url/course/search/?search=$searchQuery'),
          headers: requestHeaders);

      if (response.statusCode == 200) {
        return SearchCourseModel.fromJson(response.body);
      } else {
        print("printing from here");
        return SearchCourseModel(count: 0, next: 0, previous: 0, results: []);
      }
    } catch (e) {
      print("printing from catch");
      return SearchCourseModel(count: 0, next: 0, previous: 0, results: []);
    }
  }

  static Future<Course> getCourseDetail(String slug) async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access,
    };
    try {
      var res = await http.get(Uri.parse('$url/course/detail/$slug'),
          headers: requestHeaders);

      if (res.statusCode == 200) {
        print(res.body);
        return Course.fromJson(res.body);
      } else {
        print("From here...");
        return null;
      }
    } catch (e) {
      print("Catch from here");
      print(e.toString());
      return null;
    }
  }
}
