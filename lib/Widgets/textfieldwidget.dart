import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  final Function valfunction;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  const TextFieldWidget(
      {@required this.label,
      @required this.text,
      @required this.onChanged,
      this.valfunction,
      this.textEditingController,
      this.textInputType = TextInputType.text,
      Key key})
      : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ))),
          SizedBox(
            height: 8,
          ),
          TextFormField(
              validator: widget.valfunction,
              maxLines: 1,
              controller: widget.textEditingController,
              style: TextStyle(color: Colors.white),
              keyboardType: widget.textInputType,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)))),
        ],
      );
}
