import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  final String username;

  ContactUsPage(this.username);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: primaryColor,
          body: Stack(children: [
            Column(
              children: [
                Visibility(
                    visible: true,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/icon/icon.png'),
                    )),
                // SizedBox(),
                Text(
                  "ISCMentor",
                  style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Feel Free to Contact us",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.teal[200],
                  thickness: 2.0,
                  indent: 50.0,
                  endIndent: 50,
                ),

                Spacer(),
                Center(
                  child: Text(
                    "Copyright \u00a9 2022 ISCMentor. All Rights Reserved",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: InkWell(
                      onTap: () {
                        final url = "fb://facewebmodal/f?href=" +
                            "https://www.facebook.com/officialroutineofnepalbanda/";

                        urlLauncher(url);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration:
                            BoxDecoration(color: primaryColor, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          )
                        ]),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.facebookSquare,
                                size: 50,
                                color: Color(0xff4267B2),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Like us on facebook",
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ))
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: InkWell(
                      onTap: () async {
                        final url =
                            "https://www.messenger.com/t/100002747753545";
                        urlLauncher(url);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration:
                            BoxDecoration(color: primaryColor, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          )
                        ]),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.facebookMessenger,
                                size: 40,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Chat us on messenger",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w400)),
                              )
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: InkWell(
                      onTap: () async {
                        final toEmail = "no-reply@iscmentor.com";
                        final subject = "Message from ${widget.username}";
                        final url = 'mailto:$toEmail?subject=$subject';

                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration:
                            BoxDecoration(color: primaryColor, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          )
                        ]),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icon/gmail.png",
                                height: 40,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Contact us via email",
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ))
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ])),
    );
  }

  void urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
