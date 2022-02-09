import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  final Function valfunction;
  final TextEditingController controller;
  const DatePickerWidget(
      {@required this.label,
      @required this.text,
      @required this.onChanged,
      this.valfunction,
      this.controller,
      Key key})
      : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _date = DateTime.now();

  _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1990),
        lastDate: DateTime(2101));
    if (picked != null) {
      _date = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(_date);
      widget.controller.text = formattedDate;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ))),
          SizedBox(
            height: 8,
          ),
          TextFormField(
              readOnly: true,
              validator: widget.valfunction,
              onTap: _selectDate,
              maxLines: 1,
              controller: widget.controller,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(12)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)))),
        ],
      );
}
