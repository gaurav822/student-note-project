import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({@required this.child, @required this.direction})
      : super(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: getOffSet(), end: Offset.zero)
            .animate(animation),
        child: child,
      );

  Offset getOffSet() {
    if (direction == AxisDirection.left) {
      return Offset(-1, 0);
    } else {
      return Offset(1, 0);
    }
  }
}
