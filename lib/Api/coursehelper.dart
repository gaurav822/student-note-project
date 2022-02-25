import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_notes/Models/course_details_model.dart';
import 'package:student_notes/Models/eachchapterqmodel.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Models/questiondetailmodel.dart';
import 'package:student_notes/Models/search_course_model.dart';
import '../provider/profileprovider.dart';

class CourseHelper {
  static final String url = dotenv.get('API_URL');

  CourseHelper() {
    //
  }

  Future<String> enrollCourse({String slug, BuildContext context}) async {
    Map data = {"slug": slug};

    try {
      var response = await http.post(Uri.parse('$url/course/enroll/'),
          headers: _setHeadersForCourse(context: context),
          body: jsonEncode(data));
      if (response.statusCode == 201) {
        return response.body;
        //success
      } else if (response.statusCode == 400) {
        return "400";
        //already enrolled
      } else {
        return "404";
      }
    } catch (e) {
      return "404";
    }
  }

  Future<String> unenrollCourse({String slug, BuildContext context}) async {
    Map data = {"slug": slug};

    try {
      var response = await http.post(Uri.parse('$url/course/unenroll/'),
          headers: _setHeadersForCourse(context: context),
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return "200";
        //success
      } else {
        //failed
        return "404";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<EnrolledCourseModel> getMyCourses({BuildContext context}) async {
    try {
      var response = await http.get(Uri.parse('$url/course/mycourse/'),
          headers: _setHeadersForCourse(context: context));
      if (response.statusCode == 200) {
        return EnrolledCourseModel.fromJson(response.body);
      } else {
        return EnrolledCourseModel(count: 0, next: 0, previous: 0, results: []);
      }
    } catch (e) {
      return EnrolledCourseModel(count: 0, next: 0, previous: 0, results: []);
    }
  }

  Future<CourseList> listCourses(
      {bool sortByPopular = false,
      bool sortByNew = false,
      BuildContext context}) async {
    String finalUrl = sortByPopular
        ? url + '/course/popular-course/'
        : sortByNew
            ? url + '/course/new-course/'
            : url + '/course/all/';

    try {
      var response = await http.get(Uri.parse(finalUrl),
          headers: _setHeadersForCourse(context: context));

      return CourseList.fromJson(response.body);
    } catch (e) {
      return CourseList(count: 0, next: 0, previous: 0, results: []);
    }
  }

  Future<String> getCourseContents(
      {String slugName, BuildContext context}) async {
    try {
      var response = await http.get(Uri.parse('$url/course/content/$slugName/'),
          headers: _setHeadersForCourse(context: context));
      Map<String, dynamic> result =
          json.decode(utf8.decode(response.bodyBytes));

      var finalres = json.encode(result);

      if (response.statusCode == 200) {
        return finalres;
      } else {
        return "400";
      }
    } catch (e) {
      return "400";
    }
  }

  Future<SearchCourseModel> searchCourse(
      {String searchQuery, BuildContext context}) async {
    try {
      var response = await http.get(
          Uri.parse('$url/course/search/?search=$searchQuery'),
          headers: _setHeadersForCourse(context: context));

      Map<String, dynamic> result =
          json.decode(utf8.decode(response.bodyBytes));

      var finalres = json.encode(result);

      if (response.statusCode == 200) {
        return SearchCourseModel.fromJson(finalres);
      } else {
        return SearchCourseModel(count: 0, next: 0, previous: 0, results: []);
      }
    } catch (e) {
      return SearchCourseModel(count: 0, next: 0, previous: 0, results: []);
    }
  }

  Future<Course> getCourseDetail({String slug, BuildContext context}) async {
    try {
      var res = await http.get(Uri.parse('$url/course/detail/$slug'),
          headers: _setHeadersForCourse(context: context));

      if (res.statusCode == 200) {
        return Course.fromJson(res.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<QuestionDetailModel> fetchQuestion(
      {int courseId,
      int chapterId,
      int questionId,
      BuildContext context}) async {
    try {
      var res = await http.get(
          Uri.parse('$url/course/$courseId/$chapterId/$questionId'),
          headers: _setHeadersForCourse(context: context));
      Map<String, dynamic> result = json.decode(utf8.decode(res.bodyBytes));

      var finalres = json.encode(result);

      if (res.statusCode == 200) {
        return QuestionDetailModel.fromJson(finalres);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<EachChapterQModel> fetchCoursebyChapter(
      {int courseId, int chapterId, BuildContext context}) async {
    try {
      var res = await http.get(Uri.parse('$url/course/$courseId/$chapterId'),
          headers: _setHeadersForCourse(context: context));

      Map<String, dynamic> result = json.decode(utf8.decode(res.bodyBytes));

      var finalres = json.encode(result);

      if (res.statusCode == 200) {
        return EachChapterQModel.fromJson(finalres);
      } else {
        return EachChapterQModel(count: 0, next: 0, previous: 0, results: []);
      }
    } catch (e) {
      return EachChapterQModel(count: 0, next: 0, previous: 0, results: []);
    }
  }

  _setHeadersForCourse({BuildContext context}) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${Provider.of<ProfileProvider>(context, listen: false).getAccessToken()}'
      };
}
