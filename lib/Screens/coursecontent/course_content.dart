import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_content_model.dart';
import 'package:student_notes/Models/enrolled_course_model.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/questionanswerwidget.dart';

class CourseContent extends StatefulWidget {
  final EnrolledCourse enrolledCourse;

  CourseContent(this.enrolledCourse);

  @override
  _CourseContentState createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContent> {
  StreamController<CourseContents> _contentController = StreamController();

  int _currIndex = 0;

  List<Color> _tappedColor = List.generate(100, (index) => Colors.white);

  List<Color> _tappedColor2 = List.generate(100, (index) => Colors.blue);

  List<Chapter> chapters;

  @override
  void initState() {
    super.initState();
    fetchCourseContents();
    _tappedColor[0] = primaryColor;
    _tappedColor2[0] = Colors.white;
  }

  @override
  void dispose() {
    super.dispose();
    _contentController.close();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> fetchCourseContents() async {
    CourseContents courseContent =
        await CourseHelper.getCourseContents(widget.enrolledCourse.slug);

    List<Chapter> currchapters = courseContent.chapters;

    chapters = currchapters;
    setState(() {});

    if (!_contentController.isClosed) {
      _contentController.sink.add(courseContent);
    }
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
        chapters == null
            ? Center(child: CircularProgressIndicator())
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
            child: StreamBuilder<CourseContents>(
                stream: _contentController.stream,
                builder: (context, snapdata) {
                  switch (snapdata.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    default:
                      if (snapdata.hasError) {
                        return Center(child: Text("Error Loading Data"));
                      }
                      if (snapdata.data.chapters.isEmpty) {
                        return Center(
                            child: Text(
                          "No Data Available",
                          style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        ));
                      } else {
                        return snapdata.data.chapters[_currIndex].questions
                                    .length ==
                                0
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
                            : Container(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return QuestionAnswerWidget(
                                          snapdata.data.chapters[_currIndex],
                                          index);
                                    },
                                    itemCount: snapdata.data
                                        .chapters[_currIndex].questions.length,
                                  ),
                                ),
                              );
                      }
                  }
                }),
          ),
        ),
      ]),
    );
  }
}
