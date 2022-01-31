import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'package:student_notes/Models/course_content_model.dart';

class QuestionAnswerWidget extends StatelessWidget {
  final Chapter chapter;
  final int index;
  QuestionAnswerWidget(this.chapter, this.index);

  @override
  Widget build(BuildContext context) {
    print("This is the answer " + chapter.questions[0]["answer"]);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        // Html(
        //   data: chapter.questions[index]["question"],
        //   style: {
        //     "html": Style(fontSize: FontSize.large, fontWeight: FontWeight.bold)
        //   },
        // ),

        TeXView(
          child: TeXViewColumn(children: [
            TeXViewDocument(chapter.questions[index]["question"],
                style: TeXViewStyle(
                  fontStyle: TeXViewFontStyle(
                      fontSize: 18, fontWeight: TeXViewFontWeight.bold),
                )),
          ]),
        ),

        // Html(data: chapter.questions[0]["answer"]),

        // TeXView(
        //     renderingEngine: TeXViewRenderingEngine.mathjax(),
        //     child: TeXViewColumn(
        //         children: [TeXViewDocument(chapter.questions[0]["answer"])])),

        // Html.fromDom(
        //   document: dom.Document.html(chapter.questions[0]["answer"]),
        //   shrinkWrap: true,
        // ),

        // Markdown(data: html2md.convert(chapter.questions[0]["answer"])),

        SizedBox(
          height: 10,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TeXView(
            renderingEngine: TeXViewRenderingEngine.mathjax(),
            child: TeXViewColumn(children: [
              TeXViewDocument(
                chapter.questions[index]["answer"],
              ),
            ]),
          ),
        ),

        // Html(
        //   style: {
        //     "html": Style(
        //         fontSize: FontSize.medium, fontWeight: FontWeight.w400)
        //   },
        //   data: ((chapter.questions[index]["answer"])),
        // ),
      ]),
    );
  }
}
