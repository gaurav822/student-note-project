import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_content_model.dart';
import 'package:student_notes/Models/course_details_model.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/LoadingDialog.dart';

import '../../Models/eachchapterqmodel.dart';
import '../../Widgets/custom_page_route.dart';
import '../buyscreen/buyscreen.dart';

class CourseContent extends StatefulWidget {
  final EnrolledCourse enrolledCourse;

  CourseContent(this.enrolledCourse);

  @override
  _CourseContentState createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContent> {
  int _currIndex = 0;

  List<Color> _tappedColor = List.generate(100, (index) => Colors.white);

  List<Color> _tappedColor2 = List.generate(100, (index) => Colors.blue);

  List<Chapter> chapters = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    disableScreenShots();
    fetchCourseContents();
    _tappedColor[0] = primaryColor;
    _tappedColor2[0] = Colors.white;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> disableScreenShots() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> fetchCourseContents() async {
    String response = await CourseHelper().getCourseContents(
        slugName: widget.enrolledCourse.slug, context: context);
    if (response == "400") {
    } else {
      CourseContents courseContent = CourseContents.fromJson(response);
      List<Chapter> currchapters = courseContent.chapters;
      chapters = currchapters;
      setState(() {});
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.enrolledCourse.courseName),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : chapters.isEmpty
                ? Center(
                    child: Text("No data available"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 80,
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, index) =>
                              SizedBox(
                                width: 10,
                              ),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: chapters.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (_currIndex != index) {
                                  for (int i = 0;
                                      i < chapters[_currIndex].questions.length;
                                      i++) {
                                    chapters[_currIndex]
                                        .questions[i]
                                        .isExpanded = false;
                                  }
                                }
                                _currIndex = index;

                                for (int i = 0; i < _tappedColor.length; i++) {
                                  if (i == _currIndex) {
                                    _tappedColor[i] = primaryColor;
                                    _tappedColor2[i] = Colors.white;
                                  } else {
                                    _tappedColor[i] = Colors.white;
                                    _tappedColor2[i] = Colors.blue;
                                  }
                                }
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    color: _tappedColor[index],
                                    borderRadius: BorderRadius.circular(10)),
                                width: 150,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Center(
                                  child: Text(
                                    chapters[index].chapterTitle,
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                            color: _tappedColor2[index],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
        Divider(
          height: 5,
          color: Colors.grey,
        ),
        Container(
          child: Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : chapters.isEmpty
                    ? Center(
                        child: Text("No data available",
                            style: TextStyle(color: Colors.red, fontSize: 18)),
                      )
                    : chapters[_currIndex].questions.length == 0
                        ? Column(
                            children: [
                              SizedBox(
                                height: 200,
                              ),
                              Center(
                                child: Text("No Data Available",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18)),
                              )
                            ],
                          )
                        : SingleChildScrollView(
                            child: Container(
                              child: ExpansionPanelList.radio(
                                  elevation: 3,
                                  expansionCallback:
                                      (int index, bool isExpanded) {
                                    setState(() {
                                      chapters[_currIndex]
                                              .questions[index]
                                              .isExpanded =
                                          !chapters[_currIndex]
                                              .questions[index]
                                              .isExpanded;
                                      // widget.result.questions[index]
                                      //         .isExpanded =
                                      //     !widget.result.questions[index]
                                      //         .isExpanded;
                                    });
                                  },
                                  animationDuration:
                                      Duration(milliseconds: 600),
                                  children: chapters[_currIndex]
                                      .questions
                                      .map((Question question) {
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
                                            ? question.canView
                                                ? TeXView(
                                                    renderingEngine:
                                                        TeXViewRenderingEngine
                                                            .mathjax(),
                                                    loadingWidgetBuilder:
                                                        (context) => Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                    child: TeXViewColumn(
                                                        children: [
                                                          TeXViewDocument(
                                                              question.answer)
                                                        ]),
                                                    style: TeXViewStyle(
                                                      padding:
                                                          TeXViewPadding.all(
                                                              15),
                                                      backgroundColor:
                                                          Colors.white,
                                                    ))
                                                : Container(
                                                    width: 150,
                                                    height: 50,
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15), // <-- Radius
                                                                ),
                                                                primary: Color(
                                                                    0xfff06315c)),
                                                        onPressed: () async {
                                                          showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  LoadingDialog());
                                                          Course course = await CourseHelper()
                                                              .getCourseDetail(
                                                                  slug: widget
                                                                      .enrolledCourse
                                                                      .slug,
                                                                  context:
                                                                      context);
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context).push(
                                                              CustomPageRoute(
                                                                  child:
                                                                      BuyScreen(
                                                                    course:
                                                                        course,
                                                                  ),
                                                                  direction:
                                                                      AxisDirection
                                                                          .right));
                                                        },
                                                        child: Text(
                                                          "Premium",
                                                          style: GoogleFonts
                                                              .ubuntu(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        )))
                                            : Container());
                                  }).toList()),
                            ),
                          ),
          ),
        ),
      ]),
    );
  }
}
