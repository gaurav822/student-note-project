import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:student_notes/Models/course_content_model.dart';

class QuestionAnswerWidget extends StatelessWidget {
  final Chapter chapter;
  final int index;
  QuestionAnswerWidget(this.chapter, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Html(
          data: chapter.questions[index]["question"],
          style: {
            "html": Style(fontSize: FontSize.large, fontWeight: FontWeight.bold)
          },
        ),
        TeXView(
            loadingWidgetBuilder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
            child: TeXViewColumn(children: [
              TeXViewDocument(chapter.questions[index]["answer"])
            ])),
      ]),
    );
  }
}
