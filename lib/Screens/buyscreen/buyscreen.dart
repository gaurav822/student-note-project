import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Api/coursehelper.dart';
import 'package:student_notes/Models/course_model.dart';
import 'package:student_notes/Utils/colors.dart';

class BuyScreen extends StatefulWidget {
  final Course course;
  const BuyScreen({Key key, @required this.course}) : super(key: key);

  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    double finalPrice = widget.course.originalFee -
        widget.course.originalFee * (widget.course.discount / 100);
    AlertDialog confpayalert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure that you have already made payment ?"),
      actions: [
        TextButton(
          child: Text("Yes"),
          onPressed: () {
            _sendEnrollmentRequest(context);
          },
        ),
        TextButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
                msg: "Please check bank details and make payment",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.red,
                fontSize: 17);
          },
        ),
      ],
    );
    return WillPopScope(
      onWillPop: _isloading ? () async => false : () async => true,
      child: Scaffold(
        backgroundColor: backColor,
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: Get.width * .6,
              height: 100,
              decoration: BoxDecoration(
                  color: Color(0xfffDA492A),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                  "Please make sure to save the paid receipt when you pay for a course for confirmation",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.grey.shade400,
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(children: [
                    Center(
                      child: Container(
                        child: Text(
                          "Course",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          "Fee (Rs.)",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.course.courseName,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          "Rs. " + widget.course.originalFee.toInt().toString(),
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Center(
                      child: Container(
                        child: Text(
                          "Discount",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          widget.course.discount.toInt().toString() + "%",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Center(
                      child: Container(
                        child: Text(
                          "Total",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          "Rs. " + finalPrice.toInt().toString(),
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    )
                  ])
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Container(
                width: Get.width * .5,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // <-- Radius
                        ),
                        primary: Color(0xfff06315c)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              backgroundColor: Colors.grey.shade300,
                              content: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Account Name : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("ISC Mentor",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Bank Name : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("Siddhartha Bank",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Acc no. : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("1234556667",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Branch : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("Baneshwor",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    Text(
                                      "OR",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfffDA492A)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Image.asset(
                                      "assets/qrcode.png",
                                      height: 100,
                                      width: Get.width * .5,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    Text(
                                      "OR",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfffDA492A)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/esewa.jpg",
                                          height: 50,
                                          width: Get.width * .3,
                                        ),
                                        Image.asset(
                                          "assets/khalti.png",
                                          height: 50,
                                          width: Get.width * .3,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "9862566998",
                                      style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20)),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        width: Get.width * .3,
                                        height: 50,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // <-- Radius
                                                ),
                                                primary: Color(0xfffDA492A)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.ubuntu(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Text(
                      "Bank Details",
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ))),
            SizedBox(
              height: 20,
            ),
            Container(
                width: Get.width * .3,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // <-- Radius
                        ),
                        primary: Color(0xfffDA492A)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ))),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already made a payment ?",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    width: Get.width * .3,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // <-- Radius
                            ),
                            primary: Colors.green),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return confpayalert;
                            },
                          );
                        },
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        )))
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _sendEnrollmentRequest(BuildContext context) async {
    _isloading = true;
    setState(() {});
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Request for enrollment..."),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        });

    String res = await CourseHelper.enrollCourse(widget.course.slug);
    _isloading = false;
    setState(() {});
    if (res == "201") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Course will be Activated after Payment Verification",
          backgroundColor: Colors.green,
          fontSize: 16,
          toastLength: Toast.LENGTH_LONG);
    } else if (res == "400") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Enrollment Already Requested",
          backgroundColor: Colors.red,
          fontSize: 16,
          toastLength: Toast.LENGTH_LONG);
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Error Requesting",
        backgroundColor: Colors.red,
        fontSize: 16,
      );
    }
  }
}
