import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/Adhelper.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/admodel.dart';
import 'package:student_notes/Models/course_details_model.dart';
import 'package:student_notes/cards/AdvertiseCard.dart';
import 'package:student_notes/cards/courseCard.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isLoading = true;
  bool _isAdLoading = true;
  CourseList popularCourses, newCourses;
  AdModel adModels;

  @override
  void initState() {
    super.initState();
    fetchAdLists();
    fetchAdandCourseList();
  }

  Future<void> fetchAdandCourseList() async {
    _isLoading = true;
    CourseList popularcourseList =
        await CourseHelper().listCourses(sortByPopular: true, context: context);
    CourseList newcourseList =
        await CourseHelper().listCourses(sortByNew: true, context: context);
    popularCourses = popularcourseList;
    newCourses = newcourseList;
    _isLoading = false;
    setState(() {});
  }

  Future<void> fetchAdLists() async {
    AdModel adModel = await Adhelper().listAdvertisements(context);
    adModels = adModel;
    _isAdLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchAdandCourseList();
        setState(() {});
        return true;
      },
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),

              _isAdLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : adModels.results.isEmpty
                      ? Center(
                          child: Text("No data Found",
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red))),
                        )
                      : Container(
                          height: Get.height * .3,
                          child: Center(
                            child: CarouselSlider.builder(
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                return AdvertiseCard(
                                    adModels.results[itemIndex]);
                              },
                              itemCount: adModels.results.length,
                              options: CarouselOptions(
                                  enableInfiniteScroll: false, autoPlay: true),
                            ),
                          ),
                        ),

              SizedBox(
                height: 40,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("New Courses >>", style: TextStyle(fontSize: 18))
                ],
              ),
              SizedBox(
                height: 20,
              ),

              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : newCourses.results.isEmpty
                      ? Center(
                          child: Text("No data Found",
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red))),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: 250,
                            child: Center(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: newCourses.results.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CourseCard(
                                        newCourses.results[index]);
                                  }),
                            ),
                          ),
                        ),

              // _rowWiseCourseCarouselWidget(),

              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("Popular Courses >>", style: TextStyle(fontSize: 18))
                ],
              ),

              SizedBox(
                height: 30,
              ),

              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : popularCourses.results.isEmpty
                      ? Center(
                          child: Text("No data Found",
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red))),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: 250,
                            child: Center(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: popularCourses.results.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CourseCard(
                                        popularCourses.results[index]);
                                  }),
                            ),
                          ),
                        ),

              // _courses()
            ],
          ),
        ),
      ),
    );
  }
}
