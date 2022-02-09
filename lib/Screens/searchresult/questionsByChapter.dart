import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'package:student_notes/Models/eachchapterqmodel.dart';
import 'package:student_notes/Utils/colors.dart';

// ignore: must_be_immutable
class QuestionsbyChapter extends StatefulWidget {
  final Result result;

  QuestionsbyChapter(this.result);

  @override
  _QuestionsbyChapterState createState() => _QuestionsbyChapterState();
}

class _QuestionsbyChapterState extends State<QuestionsbyChapter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Row(
            children: [
              Text(widget.result.courseName),
              Text(":"),
              Text(widget.result.chapterTitle)
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList.radio(
                elevation: 3,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    widget.result.questions[index].isExpanded = !isExpanded;
                  });
                },
                animationDuration: Duration(milliseconds: 600),
                children: widget.result.questions.map((Question question) {
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
                        ?
                        // Html(data: question.answer)
                        TeXView(
                            loadingWidgetBuilder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                            child: TeXViewColumn(
                                children: [TeXViewDocument(question.answer)]))
                        : Container(),
                  );
                }).toList()),
          ),
        ));
  }
}
