import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_notes/Utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final bool obsecure;
  final Function valfunction;
  final Function onchanged;
  final TextEditingController textEditingController;
  CustomTextField(
      {@required this.label,
      @required this.prefixIcon,
      this.obsecure = false,
      this.valfunction,
      this.onchanged,
      this.suffixIcon,
      @required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800));
    return Container(
      width: Get.width * .7,
      child: TextFormField(
        validator: valfunction,
        controller: textEditingController,
        obscureText: obsecure,
        onChanged: onchanged,
        style: TextStyle(color: Colors.white),
        textInputAction: TextInputAction.next,
        cursorHeight: 22,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            border: border,
            enabled: true,
            focusedBorder: border,
            enabledBorder: border,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            fillColor: tfColor,
            hintText: label,
            hintStyle: TextStyle(color: Color(0xff8F8F8F)),
            filled: true),
      ),
    );
  }
}
