import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_notes/Api/userhelper.dart';
import 'package:student_notes/Models/user_model.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Widgets/datepickerWidget.dart';
import 'package:student_notes/Widgets/profile_widget.dart';
import 'package:student_notes/Widgets/textfieldwidget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key, @required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController nameController;
  TextEditingController phoneController;
  TextEditingController dobController;
  TextEditingController instituteController;
  TextEditingController addressController;
  TextEditingController studyLevelController;
  TextEditingController courseNameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userModel.name);
    phoneController = TextEditingController(text: widget.userModel.phoneNumber);
    dobController = TextEditingController(text: widget.userModel.dob);
    instituteController =
        TextEditingController(text: widget.userModel.institute);
    addressController = TextEditingController(text: widget.userModel.address);
    studyLevelController = TextEditingController(text: widget.userModel.level);
    courseNameController =
        TextEditingController(text: widget.userModel.courseName);
  }

  File image;

  Future pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return;

      final imageTemporary = File(img.path);
      setState(() {
        image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("This is  exception" + e.toString());
    }
  }

  TextEditingController intialdateval = TextEditingController();
  DateTime date = DateTime(1900);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backColor,
        body: Form(
          key: _formKey,
          child: Stack(children: [
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 30,
                ),
                ProfileWidget(
                    imagePath: widget.userModel.image,
                    isEdit: true,
                    onClicked: () async {
                      await pickImage();
                      if (image != null) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: AlertDialog(
                                  content: Row(
                                    children: [
                                      Text("Uploading..."),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                ),
                              );
                            });
                        String res =
                            await UserHelper.updateProfilePicture(image);
                        if (res == "200") {
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                          Fluttertoast.showToast(
                              msg: "Image Upload Successful");
                        } else {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: "Upload Failed");
                        }
                      }
                    }),
                SizedBox(
                  height: 24,
                ),
                TextFieldWidget(
                  textEditingController: nameController,
                  label: "Full Name",
                  text: widget.userModel.name,
                  onChanged: (name) {},
                  valfunction: (value) {
                    if (value.isEmpty) {
                      return "This field is Requred";
                    }
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                TextFieldWidget(
                  textInputType: TextInputType.number,
                  textEditingController: phoneController,
                  label: "Phone Number",
                  text: widget.userModel.phoneNumber,
                  onChanged: (number) {},
                  valfunction: (value) {
                    if (value.isEmpty) {
                      return "This field is Requred";
                    }
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                DatePickerWidget(
                  controller: dobController,
                  label: "DOB",
                  text:
                      widget.userModel.dob != null ? widget.userModel.dob : "",
                  onChanged: (dob) {},
                  valfunction: (value) {
                    if (value.isEmpty) {
                      return "This field is Requred";
                    }
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                TextFieldWidget(
                  textEditingController: instituteController,
                  label: "Institute",
                  text: widget.userModel.institute != null
                      ? widget.userModel.institute
                      : "",
                  onChanged: (institute) {},
                  valfunction: (value) {
                    if (value.isEmpty) {
                      return "This field is Requred";
                    }
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                TextFieldWidget(
                  textEditingController: studyLevelController,
                  label: "Study Level",
                  text: "",
                  onChanged: (stulevel) {},
                ),
                SizedBox(
                  height: 24,
                ),
                TextFieldWidget(
                  textEditingController: courseNameController,
                  label: "Course Name",
                  text: "",
                  onChanged: (cname) {},
                ),
                SizedBox(
                  height: 24,
                ),
                TextFieldWidget(
                  textEditingController: addressController,
                  label: "Address",
                  text: widget.userModel.address != null
                      ? widget.userModel.address
                      : "",
                  onChanged: (address) {},
                  valfunction: (value) {
                    if (value.isEmpty) {
                      return "This field is Requred";
                    }
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ElevatedButton(
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      validateUserInfo();
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              child: new IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              top: 0,
              left: 0,
            ),
          ]),
        ),
      ),
    );
  }

  validateUserInfo() {
    if (_formKey.currentState.validate()) {
      updateUserInfo(context);
    } else {
      print("not valid");
    }
  }

  void updateUserInfo(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                Text("Updating Info..."),
                SizedBox(
                  width: 30,
                ),
                CircularProgressIndicator(),
              ],
            ),
          );
        });

    String name = nameController.text.toString();
    String phone = phoneController.text.toString().trim();
    String dob = dobController.text.toString();
    String institute = instituteController.text.toString();
    String address = addressController.text.toString();
    String courseName = courseNameController.text.toString();
    String studyLevel = studyLevelController.text.toString();

    print("The details are " + name + phone + dob + institute + address);

    String response = await UserHelper.updateUserInfo(
        fullName: name,
        phoneNumber: phone,
        dateOfBirth: dob,
        institute: institute,
        address: address,
        coursename: courseName,
        studylevel: studyLevel);

    if (response == "200") {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
      Fluttertoast.showToast(
          msg: "Data Updated Successfully", backgroundColor: Colors.green);
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: response.toString());
    }
  }
}
