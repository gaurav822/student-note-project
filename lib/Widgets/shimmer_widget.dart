import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final bool isCicular;

  const ShimmerWidget.rectangular(
      {this.width = double.infinity,
      @required this.height,
      this.isCicular = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400],
      highlightColor: Colors.grey[300],
      child: isCicular
          ? ClipOval(
              child: Container(
                width: width,
                height: height,
                color: Colors.grey,
              ),
            )
          : Container(
              width: width,
              height: height,
              color: Colors.grey,
            ),
    );
  }
}
