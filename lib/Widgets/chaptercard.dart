import 'package:flutter/material.dart';
import 'package:student_notes/Models/course_content_model.dart';

class ChapterCard extends StatelessWidget {
  final Chapter chapter;

  ChapterCard(this.chapter);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Text(chapter.chapterTitle)],
      ),
    );
  }
}
