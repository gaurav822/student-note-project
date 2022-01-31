import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/Adhelper.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/admodel.dart';
import 'package:student_notes/Models/course_model.dart';
import 'package:student_notes/cards/AdvertiseCard.dart';
import 'package:student_notes/Widgets/courseCard.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  StreamController<AdModel> _streamController1 = StreamController();
  StreamController<CourseList> _streamController2 = StreamController();
  StreamController<CourseList> _streamController3 = StreamController();
  Timer _timer;

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
    _streamController1.close();
    _streamController2.close();
    _streamController3.close();
    print("Calling dispose from here");
  }

  @override
  void initState() {
    super.initState();

    // fetchAdandCourseList();

    _timer = new Timer.periodic(Duration(seconds: 3), (timer) {
      fetchAdandCourseList();
      // print("timer still running");
    });
  }

  Future<void> fetchAdandCourseList() async {
    // CourseList courseList = await CourseHelper.listCourses();
    CourseList popularcourseList =
        await CourseHelper.listCourses(sortByPopular: true);
    CourseList newcourseList = await CourseHelper.listCourses(sortByNew: true);

    AdModel adModel = await Adhelper.listAdvertisements();

    if (!_streamController1.isClosed) {
      _streamController1.sink.add(adModel);
    }

    if (!_streamController2.isClosed) {
      _streamController2.sink.add(newcourseList);
    }

    if (!_streamController3.isClosed) {
      _streamController3.sink.add(popularcourseList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),

            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text("Ads", style: TextStyle(color: Colors.white, fontSize: 18))
              ],
            ),
            SizedBox(
              height: 20,
            ),

            StreamBuilder<AdModel>(
                stream: _streamController1.stream,
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
                            child: Text(
                          "No ads available",
                          style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        ));
                      } else {
                        return Container(
                          height: Get.height * .3,
                          child: Center(
                            child: CarouselSlider.builder(
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                return AdvertiseCard(
                                    snapdata.data.results[itemIndex]);
                              },
                              itemCount: snapdata.data.results.length,
                              options: CarouselOptions(
                                  enableInfiniteScroll: false, autoPlay: true),
                            ),
                          ),
                        );
                      }
                  }
                }),

            SizedBox(
              height: 40,
            ),

            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text("New Courses >>",
                    style: TextStyle(color: Colors.white, fontSize: 18))
              ],
            ),
            SizedBox(
              height: 20,
            ),

            StreamBuilder<CourseList>(
                stream: _streamController2.stream,
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: 250,
                            child: Center(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapdata.data.results.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CourseCard(
                                        snapdata.data.results[index]);
                                  }),
                            ),
                          ),
                        );
                      }
                  }
                }),

            // _rowWiseCourseCarouselWidget(),

            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text("Popular Courses >>",
                    style: TextStyle(color: Colors.white, fontSize: 18))
              ],
            ),

            SizedBox(
              height: 30,
            ),

            StreamBuilder<CourseList>(
                stream: _streamController3.stream,
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: 250,
                            child: Center(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapdata.data.results.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CourseCard(
                                        snapdata.data.results[index]);
                                  }),
                            ),
                          ),
                        );
                      }
                  }
                })

            // _courses()
          ],
        ),
      ),
    );
  }
}
