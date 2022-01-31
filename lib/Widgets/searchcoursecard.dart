import 'package:flutter/material.dart';
import 'package:student_notes/Models/search_course_model.dart';

class SearchCard extends StatelessWidget {
  final SearchCourse searchCourse;

  SearchCard(this.searchCourse);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            searchCourse.courseName,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
