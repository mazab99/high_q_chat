
import 'package:flutter/material.dart';

class VerticalLine extends StatelessWidget {
  const VerticalLine({
    Key? key,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.verticalBarColor,
    this.verticalBarWidth,
  }) : super(key: key);

  /// Allow user to set color of bar
  final Color? verticalBarColor;

  /// Allow user to set left padding.
  final double leftPadding;

  /// Allow user to set left padding.
  final double rightPadding;

  /// Allow user to set width of bar.
  final double? verticalBarWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: verticalBarWidth ?? 2.5,
      color: verticalBarColor ?? Colors.grey.shade300,
      margin: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
      ),
    );
  }
}
