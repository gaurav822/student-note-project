import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_details_model.dart';
import 'package:student_notes/Models/search_course_model.dart';
import 'package:student_notes/Screens/searchresult/searchresultpage.dart';
import 'package:student_notes/cards/courseCard.dart';
import 'package:student_notes/provider/profileprovider.dart';

import '../../../SecuredStorage/securedstorage.dart';

class BrowseCourse extends StatefulWidget {
  const BrowseCourse({Key key}) : super(key: key);

  @override
  _BrowseCourseState createState() => _BrowseCourseState();
}

class _BrowseCourseState extends State<BrowseCourse> {
  TextEditingController textController = TextEditingController();
  StreamController<CourseList> _allCourseStream = StreamController();
  CourseList courseList;

  StreamController<SearchCourseModel> searchCourseStream =
      StreamController<SearchCourseModel>.broadcast();

  bool _isSearching = false;
  bool _isLoading = true;

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
    setAccessToken();
    fetchAllCoursesList();
  }

  Future<void> setAccessToken() async {
    String access = await SecuredStorage.getAccess();
    Provider.of<ProfileProvider>(context, listen: false).setAccess(access);
  }

  Future<void> fetchAllCoursesList() async {
    _isLoading = true;
    CourseList allCourses = await CourseHelper().listCourses(context: context);
    courseList = allCourses;
    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchSearchedCoursesList() async {
    SearchCourseModel searchCourseModel = await CourseHelper()
        .searchCourse(searchQuery: textController.text, context: context);

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
                  if (value.isEmpty || value.length < 3) {
                    Fluttertoast.showToast(
                        msg: "Please enter at least 3 character",
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
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : courseList.results.isEmpty
                        ? Center(
                            child: Text(
                              "No data found",
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      fontSize: 20, color: Colors.red)),
                            ),
                          )
                        : Container(
                            child: Center(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  fetchAllCoursesList();
                                  setState(() {});
                                  return true;
                                },
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    itemCount: courseList.results.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        child: CourseCard(
                                            courseList.results[index]),
                                      );
                                    }),
                              ),
                            ),
                          ),
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
