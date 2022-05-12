// @dart=2.9
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class AppData extends StatelessWidget {
  const AppData({
    Key key,
    @required this.dataLabel,
    this.fontWeight,
    this.fontSize,
    this.colour,
  }) : super(key: key);

  final String dataLabel;
  final FontWeight fontWeight;
  final double fontSize;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        dataLabel,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: colour,
        ),
      ),
    );
  }
}
