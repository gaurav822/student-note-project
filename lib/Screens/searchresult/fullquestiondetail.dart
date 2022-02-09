import 'package:flutter/material.dart';
import 'package:student_notes/Models/questiondetailmodel.dart';
import 'package:student_notes/Utils/colors.dart';

class FullQuestionDetailPage extends StatefulWidget {
  final QuestionDetailModel questionDetailModel;
  FullQuestionDetailPage(this.questionDetailModel);

  @override
  State<FullQuestionDetailPage> createState() => _FullQuestionDetailPageState();
}

class _FullQuestionDetailPageState extends State<FullQuestionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                ExpansionTile(
                  title: Text("test"),
                  // title: Html(
                  //   data: widget.questionDetailModel.question,
                  //   style: {
                  //     "html": Style(
                  //       fontSize: FontSize.large,
                  //       fontWeight: FontWeight.normal,
                  //     )
                  //   },
                  // ),
                  children: [
                    // TeXView(
                    //   loadingWidgetBuilder: (context) =>
                    //       Center(child: CircularProgressIndicator()),
                    //   renderingEngine: TeXViewRenderingEngine.mathjax(),
                    //   child: TeXViewColumn(children: [
                    //     TeXViewDocument(
                    //       widget.questionDetailModel.answer,
                    //     ),
                    //   ]),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   color: Colors.white,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),

                //     child: Html(
                //       data: widget.questionDetailModel.answer,
                //       style: {
                //         "html": Style(
                //           color: Colors.black,
                //           fontSize: FontSize.large,
                //           fontWeight: FontWeight.normal,
                //         )
                //       },
                //     ),
                // child: TeXView(
                //   loadingWidgetBuilder: (context) =>
                //       Center(child: CircularProgressIndicator()),
                //   renderingEngine: TeXViewRenderingEngine.mathjax(),
                //   child: TeXViewColumn(children: [
                //     TeXViewDocument(
                //       widget.questionDetailModel.answer,
                //     ),
                //   ]),
                // ),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
