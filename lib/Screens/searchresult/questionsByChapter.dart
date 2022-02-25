import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Models/course_details_model.dart';
import 'package:student_notes/Models/eachchapterqmodel.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';
import '../../Api/coursehelper.dart';
import '../../Models/enrolled_course_model.dart';
import '../../Widgets/custom_page_route.dart';
import '../../provider/enrolledcoursesprovider.dart';
import '../buyscreen/buyscreen.dart';

// ignore: must_be_immutable
class QuestionsbyChapter extends StatefulWidget {
  final Result result;
  final Course course;
  QuestionsbyChapter({this.result, this.course});

  @override
  _QuestionsbyChapterState createState() => _QuestionsbyChapterState();
}

class _QuestionsbyChapterState extends State<QuestionsbyChapter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Row(
            children: [
              Text(widget.result.courseName),
              Text(":"),
              Flexible(
                  child: Tooltip(
                      message: widget.result.chapterTitle,
                      child: Text(widget.result.chapterTitle)))
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList.radio(
                elevation: 3,
                expansionCallback: (int index, bool isExpanded) {
                  // print("→");
                  // log(widget.result.questions[index].answer);
                  setState(() {
                    widget.result.questions[index].isExpanded =
                        !widget.result.questions[index].isExpanded;
                  });
                },
                animationDuration: Duration(milliseconds: 600),
                children: widget.result.questions.map((Question question) {
                  return ExpansionPanelRadio(
                      value: question.id,
                      headerBuilder: (
                        BuildContext context,
                        bool isExpanded,
                      ) {
                        return Html(data: question.question);
                      },
                      canTapOnHeader: true,
                      body: question.isExpanded
                          ? !question.canView
                              ? Container(
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
                                      onPressed: () {
                                        widget.result.isPremium
                                            ? Navigator.of(context).push(
                                                CustomPageRoute(
                                                    child: BuyScreen(
                                                        course: widget.course,
                                                        requestFromChapter:
                                                            true),
                                                    direction:
                                                        AxisDirection.right))
                                            : _enrollFreeCourse(widget.result);
                                      },
                                      child: Text(
                                        question.answer == "premium"
                                            ? "Premium"
                                            : "Enroll",
                                        style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )))
                              : TeXView(
                                  style: TeXViewStyle(
                                    padding: TeXViewPadding.all(15),
                                    backgroundColor: Colors.white,
                                  ),
                                  renderingEngine:
                                      TeXViewRenderingEngine.mathjax(),
                                  loadingWidgetBuilder: (context) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  child: TeXViewColumn(children: [
                                    TeXViewDocument(question.answer)
                                  ]),
                                )
                          : Container());
                }).toList()),
          ),
        ));
  }

  _enrollFreeCourse(Result result) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => LoadingDialog(
              loadText: "Enrolling...",
            ));
    String res = await CourseHelper()
        .enrollCourse(slug: result.courseName.toLowerCase(), context: context);
    Navigator.of(context).pop();
    if (res == "400") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Already Enrolled in this Course",
          backgroundColor: Colors.red,
          fontSize: 16,
          toastLength: Toast.LENGTH_LONG);
    } else if (res == "404") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Error Enrolling",
        backgroundColor: Colors.red,
        fontSize: 16,
      );
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Enrolled Successfully !",
          backgroundColor: Colors.green,
          fontSize: 17,
          toastLength: Toast.LENGTH_LONG);
      EnrolledCourse course = EnrolledCourse.fromMap(jsonDecode(res)["data"]);
      Provider.of<EnrolledCourseProvider>(context, listen: false)
          .addnewCourse(course);
    }
  }
}
