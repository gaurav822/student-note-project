import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_model.dart';
import 'package:student_notes/Models/search_course_model.dart';
import 'package:student_notes/Screens/searchresult/searchresultpage.dart';
import 'package:student_notes/Widgets/courseCard.dart';

class BrowseCourse extends StatefulWidget {
  const BrowseCourse({Key key}) : super(key: key);

  @override
  _BrowseCourseState createState() => _BrowseCourseState();
}

class _BrowseCourseState extends State<BrowseCourse> {
  TextEditingController textController = TextEditingController();
  StreamController<CourseList> _allCourseStream = StreamController();

  StreamController<SearchCourseModel> searchCourseStream =
      StreamController<SearchCourseModel>.broadcast();

  bool _isSearching = false;

  @override
  void dispose() {
    textController.clear();
    _allCourseStream.close();
    searchCourseStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchAllCoursesList();
  }

  Future<void> fetchAllCoursesList() async {
    CourseList allCourses = await CourseHelper.listCourses();

    if (!_allCourseStream.isClosed) {
      _allCourseStream.sink.add(allCourses);
    }
  }

  Future<void> fetchSearchedCoursesList() async {
    SearchCourseModel searchCourseModel =
        await CourseHelper.searchCourse(searchQuery: textController.text);

    //converting search model to CourseDetail Model
    // List<Course> lists = [];
    // lists.length = searchCourseModel.results.length;
    // for (int i = 0; i < lists.length; i++) {
    //   if (searchCourseModel.results[i].courseName != null) {
    //     Course eachCourse = await CourseHelper.getCourseDetail(
    //         searchCourseModel.results[i].courseSlug);
    //     lists[i] = eachCourse;
    //   }
    // }
    // _searchedCourses = lists;
    // setState(() {});
    if (!searchCourseStream.isClosed) {
      searchCourseStream.sink.add(searchCourseModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800));
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Get.height,
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                focusNode: FocusNode(),
                controller: textController,
                style: TextStyle(color: Colors.black),
                textInputAction: TextInputAction.search,
                cursorHeight: 22,
                cursorColor: Colors.grey,
                onChanged: (value) {
                  if (value.toString().length == 0) {
                    _isSearching = false;
                    searchCourseStream.add(null);
                    setState(() {});
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Please enter something..",
                        backgroundColor: Colors.red,
                        fontSize: 16);
                  } else {
                    fetchSearchedCoursesList();
                    _isSearching = true;
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                    border: border,
                    enabled: true,
                    focusedBorder: border,
                    enabledBorder: border,
                    suffixIcon: InkWell(
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onTap: () {
                          textController.clear();
                          searchCourseStream.add(null);

                          _isSearching = false;
                          setState(() {});
                        }),
                    prefixIcon: InkWell(
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Search...",
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Color(0xff8F8F8F)),
                    filled: true),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Stack(children: [
                StreamBuilder<CourseList>(
                    stream: _allCourseStream.stream,
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
                          if (snapdata.data.results.isBlank) {
                            return Center(
                                child: Text("No data Found",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red))));
                          } else {
                            return Container(
                              child: Center(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    itemCount: snapdata.data.results.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        child: CourseCard(
                                            snapdata.data.results[index]),
                                      );
                                    }),
                              ),
                            );
                          }
                      }
                    }),
                _isSearching
                    ? StreamBuilder<SearchCourseModel>(
                        stream: searchCourseStream.stream,
                        builder: (context, snapdata) {
                          switch (snapdata.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                height: Get.height,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                            default:
                              if (snapdata.hasError) {
                                return Center(
                                    child: Text("Error Loading Data"));
                              }
                              if (snapdata.data.results.isBlank) {
                                return Container(
                                  height: Get.height,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Center(
                                      child: Text("No data Found",
                                          style: GoogleFonts.ubuntu(
                                              textStyle: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)))),
                                );
                              } else {
                                return Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Center(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(
                                            parent:
                                                AlwaysScrollableScrollPhysics()),
                                        itemCount: snapdata.data.results.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: SearchResultPage(
                                                snapdata.data.results[index]),
                                          );
                                        }),
                                  ),
                                );
                              }
                          }
                        })
                    : SizedBox()
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
