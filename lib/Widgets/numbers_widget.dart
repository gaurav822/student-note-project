import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, '0', 'Premium Courses'),
            buildDivider(),
            buildButton(context, '2021', 'Active Since'),
            buildDivider(),
            buildButton(context, '0', 'Free Courses'),
          ],
        ),
      );

  Widget buildDivider() => Container(
      height: 24,
      child: VerticalDivider(
        color: Colors.grey.shade100,
      ));

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        onPressed: () {},
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              text,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      );
}
