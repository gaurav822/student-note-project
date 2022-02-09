import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_model.dart';
import 'package:student_notes/Models/eachchapterqmodel.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Models/questiondetailmodel.dart';
import 'package:student_notes/Models/search_course_model.dart';
import 'package:student_notes/Screens/buyscreen/buyscreen.dart';
import 'package:student_notes/Screens/coursecontent/course_content.dart';
import 'package:student_notes/Screens/searchresult/fullquestiondetail.dart';
import 'package:student_notes/Screens/searchresult/questionsByChapter.dart';
import 'package:student_notes/Widgets/custom_page_route.dart';

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

    QuestionDetailModel qmodel = await CourseHelper.fetchQuestion(
        widget.scourse.courseId,
        widget.scourse.chapterId,
        widget.scourse.quesId);
    if (qmodel != null) {
      if (qmodel.canView) {
        Navigator.of(context).pop();
        Navigator.of(context).push(CustomPageRoute(
            child: FullQuestionDetailPage(qmodel),
            direction: AxisDirection.right));
      } else {
        EachChapterQModel eachChapterQModel =
            await CourseHelper.fetchCoursebyChapter(
                widget.scourse.courseId, widget.scourse.chapterId);
        if (eachChapterQModel.results[0].isPremium) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Cannot view premium content. Please buy " +
                  eachChapterQModel.results[0].courseName +
                  " course first",
              backgroundColor: Colors.red);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Free content but please enroll in " +
                  eachChapterQModel.results[0].courseName +
                  " first",
              backgroundColor: Colors.red);
        }
      }
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

    Course course =
        await CourseHelper.getCourseDetail(widget.scourse.courseSlug);

    if (course != null) {
      if (course.isPremium) {
        Navigator.of(context).pop();
        Get.to(BuyScreen(course: course));
      } else {
        String res = await CourseHelper.enrollCourse(course.slug);
        if (res == "201") {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Now you are enrolled in this course",
              backgroundColor: Colors.green,
              fontSize: 16,
              toastLength: Toast.LENGTH_LONG);
          Get.to(CourseContent(EnrolledCourse(
              description: course.description,
              enrolledAt: null,
              grade: course.grade,
              image: course.image,
              paid: null,
              slug: course.slug,
              courseName: course.courseName,
              isPremium: course.isPremium)));
        } else if (res == "400") {
          Navigator.of(context).pop();
          Get.to(CourseContent(EnrolledCourse(
              description: course.description,
              enrolledAt: null,
              grade: course.grade,
              image: course.image,
              paid: null,
              slug: course.slug,
              courseName: course.courseName,
              isPremium: course.isPremium)));
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Error Enrolling into course",
            backgroundColor: Colors.red,
            fontSize: 16,
          );
        }
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
    EachChapterQModel eachChapterQModel =
        await CourseHelper.fetchCoursebyChapter(
            widget.scourse.courseId, widget.scourse.chapterId);
    Result result = eachChapterQModel.results[0];

    if (result != null) {
      if (result.isPremium) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Please buy " + result.courseName + " to access",
            backgroundColor: Colors.red);
      } else {
        String res =
            await CourseHelper.enrollCourse(result.courseName.toLowerCase());
        if (res == "201") {
          EachChapterQModel eachChapterQModel =
              await CourseHelper.fetchCoursebyChapter(
                  widget.scourse.courseId, widget.scourse.chapterId);
          Result result = eachChapterQModel.results[0];
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Now you are enrolled in this course",
              backgroundColor: Colors.green,
              fontSize: 16,
              toastLength: Toast.LENGTH_LONG);
          Get.to(() => QuestionsbyChapter(result));
        } else if (res == "400") {
          Navigator.of(context).pop();
          Get.to(() => QuestionsbyChapter(result));
        } else {
          Get.to(() => QuestionsbyChapter(result));
          Navigator.of(context).pop();
        }
      }
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "No data available", backgroundColor: Colors.red);
    }
  }
}
