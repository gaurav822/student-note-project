import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_details_model.dart';
import 'package:student_notes/Models/eachchapterqmodel.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Models/questiondetailmodel.dart';
import 'package:student_notes/Models/search_course_model.dart';
import 'package:student_notes/Screens/buyscreen/buyscreen.dart';
import 'package:student_notes/Screens/coursecontent/course_content.dart';
import 'package:student_notes/Screens/searchresult/fullquestiondetail.dart';
import 'package:student_notes/Screens/searchresult/questionsByChapter.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';
import 'package:student_notes/Widgets/custom_page_route.dart';

import '../../provider/enrolledcoursesprovider.dart';

class SearchResultPage extends StatefulWidget {
  final SearchCourse scourse;

  SearchResultPage(this.scourse);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      widget.scourse.courseName != null
          ? InkWell(
              onTap: () {
                viewCourse();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  width: Get.width * .7,
                  height: 150,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      // image: DecorationImage(
                      //     image: CachedNetworkImageProvider(
                      //         "https://toppng.com/uploads/preview/no-transparent-png-11553948930lzlqecvumq.png"),
                      //     fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(spreadRadius: .5, color: Colors.white)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Course",
                        style: GoogleFonts.ubuntu(
                            textStyle:
                                TextStyle(fontSize: 14, color: Colors.black)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.scourse.courseName,
                        style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox(),
      widget.scourse.chapterTitle != null
          ? InkWell(
              onTap: () {
                viewCoursebyChapter();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                    height: 100,
                    width: 250,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        // image: DecorationImage(
                        //     image: CachedNetworkImageProvider(
                        //         "https://toppng.com/uploads/preview/no-transparent-png-11553948930lzlqecvumq.png"),
                        //     fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(spreadRadius: .5, color: Colors.white)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Chapter",
                          style: GoogleFonts.ubuntu(
                              textStyle:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                        ),
                        Text(
                          widget.scourse.chapterTitle,
                          style: GoogleFonts.ubuntu(
                              textStyle:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                        ),
                      ],
                    )),
              ),
            )
          : SizedBox(),
      widget.scourse.question != null
          ? InkWell(
              onTap: () {
                viewQuestion();
              },
              child: Html(
                data: widget.scourse.question,
                style: {
                  "html": Style(
                    maxLines: 2,
                    textOverflow: TextOverflow.fade,
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.normal,
                  )
                },
              ),
            )
          : SizedBox()
    ]);
  }

  void viewQuestion() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Please wait..."),
                    SizedBox(
                      width: 20,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ));

    QuestionDetailModel qmodel = await CourseHelper().fetchQuestion(
        courseId: widget.scourse.courseId,
        chapterId: widget.scourse.chapterId,
        questionId: widget.scourse.quesId,
        context: context);

    if (qmodel != null) {
      Navigator.of(context).pop();
      Navigator.of(context).push(CustomPageRoute(
          child: FullQuestionDetailPage(qmodel, widget.scourse),
          direction: AxisDirection.right));
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Error fetching question");
    }
  }

  void viewCourse() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Fetching contents.."),
                    SizedBox(
                      width: 20,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ));

    Course course = await CourseHelper()
        .getCourseDetail(slug: widget.scourse.courseSlug, context: context);

    EnrolledCourse enrolledCourse = EnrolledCourse(
        description: course.description,
        enrolledAt: null,
        grade: course.grade,
        image: course.image,
        paid: null,
        slug: course.slug,
        courseName: course.courseName,
        isPremium: course.isPremium);

    if (course != null) {
      if (course.isPremium) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Premium Course !",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                  fontSize: 18,
                )),
              ),
              content: Text("Please choose the action below"),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: primaryColor),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => LoadingDialog(
                              loadText: "Enrolling...",
                            ));

                    String res = await CourseHelper()
                        .enrollCourse(slug: course.slug, context: context);
                    Navigator.of(context).pop();
                    if (res == "400") {
                      Navigator.of(context).pop();
                      Get.to(() => CourseContent(enrolledCourse));
                    } else if (res == "404") {
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(
                        msg: "Error Enrolling into course",
                        backgroundColor: Colors.red,
                        fontSize: 16,
                      );
                    } else {
                      Navigator.of(context).pop();
                      EnrolledCourse course =
                          EnrolledCourse.fromMap(jsonDecode(res)["data"]);
                      Fluttertoast.showToast(
                          msg: "Enrolled Successfully to " + course.courseName,
                          backgroundColor: Colors.green,
                          fontSize: 17,
                          toastLength: Toast.LENGTH_LONG);

                      Provider.of<EnrolledCourseProvider>(context,
                              listen: false)
                          .addnewCourse(course);
                      Get.to(() => CourseContent(course));
                    }
                  },
                  child: Text("Enroll", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: primaryColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuyScreen(
                                  course: course,
                                )),
                      );
                    },
                    child: Text(
                      "Pay Now",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          },
        );
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    "Free Course !",
                    style:
                        GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: 18)),
                  ),
                  content: Text("You must enroll to access contents"),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: primaryColor),
                        onPressed: () async {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext ctx) => WillPopScope(
                                  onWillPop: () async => false,
                                  child: LoadingDialog()));
                          String res = await CourseHelper().enrollCourse(
                              slug: course.slug, context: context);
                          Navigator.of(context).pop();
                          if (res == "400") {
                            Navigator.of(context).pop();
                            Get.to(() => CourseContent(enrolledCourse));
                          } else if (res == "404") {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                              msg: "Error Enrolling into course",
                              backgroundColor: Colors.red,
                              fontSize: 16,
                            );
                          } else {
                            Navigator.of(context).pop();
                            EnrolledCourse course =
                                EnrolledCourse.fromMap(jsonDecode(res)["data"]);
                            Fluttertoast.showToast(
                                msg: "Enrolled Successfully to " +
                                    course.courseName,
                                backgroundColor: Colors.green,
                                fontSize: 17,
                                toastLength: Toast.LENGTH_LONG);

                            Provider.of<EnrolledCourseProvider>(context,
                                    listen: false)
                                .addnewCourse(course);
                            Get.to(() => CourseContent(course));
                          }
                        },
                        child: Text(
                          "Enroll",
                          style: TextStyle(color: Colors.white),
                        )),
                    cancelButton()
                  ],
                ));
      }
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Error fetching course details", backgroundColor: Colors.red);
    }
  }

  void viewCoursebyChapter() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: Row(
                  children: [
                    Text("Please wait..."),
                    SizedBox(
                      width: 20,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ));

    EachChapterQModel eachChapterQModel = await CourseHelper()
        .fetchCoursebyChapter(
            courseId: widget.scourse.courseId,
            chapterId: widget.scourse.chapterId,
            context: context);
    Result result = eachChapterQModel.results[0];
    String slug = result.courseName.toString();

    if (result != null) {
      if (result.isPremium) {
        Course course =
            await CourseHelper().getCourseDetail(slug: slug, context: context);
        Navigator.of(context).pop();
        Get.to(() => QuestionsbyChapter(
              result: result,
              course: course,
            ));
      } else {
        Navigator.of(context).pop();
        Get.to(() => QuestionsbyChapter(
              result: result,
            ));
      }
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "No data available", backgroundColor: Colors.red);
    }
  }

  Widget cancelButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: cancelColor),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.white),
        ));
  }
}
