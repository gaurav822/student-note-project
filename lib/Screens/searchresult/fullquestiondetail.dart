import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_details_model.dart';
import 'package:student_notes/Models/questiondetailmodel.dart';
import 'package:student_notes/Models/search_course_model.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';

import '../../Models/eachchapterqmodel.dart';
import '../../Models/enrolled_course_model.dart';
import '../../Widgets/custom_page_route.dart';
import '../../provider/enrolledcoursesprovider.dart';
import '../buyscreen/buyscreen.dart';

class FullQuestionDetailPage extends StatefulWidget {
  final QuestionDetailModel questionDetailModel;
  final SearchCourse scourse;
  FullQuestionDetailPage(this.questionDetailModel, this.scourse);

  @override
  State<FullQuestionDetailPage> createState() => _FullQuestionDetailPageState();
}

class _FullQuestionDetailPageState extends State<FullQuestionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                ExpansionTile(
                  title: Html(
                    data: widget.questionDetailModel.question,
                  ),
                  children: [
                    widget.questionDetailModel.canView
                        ? TeXView(
                            style: TeXViewStyle(
                              padding: TeXViewPadding.all(15),
                              backgroundColor: Colors.white,
                            ),
                            loadingWidgetBuilder: (context) =>
                                Center(child: CircularProgressIndicator()),
                            renderingEngine: TeXViewRenderingEngine.mathjax(),
                            child: TeXViewColumn(children: [
                              TeXViewDocument(
                                widget.questionDetailModel.answer,
                              ),
                            ]),
                          )
                        : Container(
                            width: 150,
                            height: 50,
                            padding: EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15), // <-- Radius
                                    ),
                                    primary: Color(0xfff06315c)),
                                onPressed: () async {
                                  if (widget.questionDetailModel.answer ==
                                      "premium") {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            LoadingDialog());
                                    EachChapterQModel eachChapterQModel =
                                        await CourseHelper()
                                            .fetchCoursebyChapter(
                                                courseId:
                                                    widget.scourse.courseId,
                                                chapterId:
                                                    widget.scourse.chapterId,
                                                context: context);

                                    Course course = await CourseHelper()
                                        .getCourseDetail(
                                            slug: eachChapterQModel
                                                .results[0].courseName
                                                .toLowerCase(),
                                            context: context);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(CustomPageRoute(
                                        child: BuyScreen(course: course),
                                        direction: AxisDirection.right));
                                  } else {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            LoadingDialog(
                                              loadText: "Enrolling...",
                                            ));
                                    EachChapterQModel eachChapterQModel =
                                        await CourseHelper()
                                            .fetchCoursebyChapter(
                                                courseId:
                                                    widget.scourse.courseId,
                                                chapterId:
                                                    widget.scourse.chapterId,
                                                context: context);

                                    String result = await CourseHelper()
                                        .enrollCourse(
                                            slug: eachChapterQModel
                                                .results[0].courseName
                                                .toLowerCase(),
                                            context: context);
                                    Navigator.of(context).pop();

                                    if (result == "400") {
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                          msg:
                                              "Already Enrolled in this Course",
                                          backgroundColor: Colors.red,
                                          fontSize: 16,
                                          toastLength: Toast.LENGTH_LONG);
                                    } else if (result == "404") {
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                        msg: "Error Enrolling",
                                        backgroundColor: Colors.red,
                                        fontSize: 16,
                                      );
                                    } else {
                                      Navigator.of(context).pop();

                                      EnrolledCourse course =
                                          EnrolledCourse.fromMap(
                                              jsonDecode(result)["data"]);
                                      Fluttertoast.showToast(
                                          msg: "Enrolled Successfully to " +
                                              course.courseName,
                                          backgroundColor: Colors.green,
                                          fontSize: 17,
                                          toastLength: Toast.LENGTH_LONG);
                                      Provider.of<EnrolledCourseProvider>(
                                              context,
                                              listen: false)
                                          .addnewCourse(course);
                                    }
                                  }
                                },
                                child: Text(
                                  widget.questionDetailModel.answer == "premium"
                                      ? "premium"
                                      : "Enroll",
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ))),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
