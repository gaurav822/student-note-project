import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  final int premium, free;
  NumbersWidget(this.premium, this.free);
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, premium.toString(), 'Premium Courses'),
            buildDivider(),
            buildButton(context, '2021', 'Active Since'),
            buildDivider(),
            buildButton(context, free.toString(), 'Free Courses'),
          ],
        ),
      );

  Widget buildDivider() => Container(height: 24, child: VerticalDivider());

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
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
}
