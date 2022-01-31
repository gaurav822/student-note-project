import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;

  final Function searchCourseFunction;
  final Function onChangedFuncion;
  final Function onClear;

  CustomSearchBar(
      {@required this.searchController,
      this.searchCourseFunction,
      this.onClear,
      this.onChangedFuncion});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800));
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        focusNode: FocusNode(),
        controller: searchController,
        style: TextStyle(color: Colors.black),
        textInputAction: TextInputAction.search,
        cursorHeight: 22,
        cursorColor: Colors.grey,
        onChanged: onChangedFuncion,
        onFieldSubmitted: searchCourseFunction,
        decoration: InputDecoration(
            border: border,
            enabled: true,
            focusedBorder: border,
            enabledBorder: border,
            suffixIcon: InkWell(child: Icon(Icons.close), onTap: onClear),
            prefixIcon: InkWell(
              child: Icon(Icons.search),
            ),
            hintText: "Search...",
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Color(0xff8F8F8F)),
            filled: true),
      ),
    );
  }
}
