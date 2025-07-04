import 'package:flutter/material.dart';

class customText extends StatelessWidget {
  final String title;
  final double fontSize;
  const customText({super.key, required this.title, required this.fontSize});
  @override
  Widget build(BuildContext context) {
    return
      Text(
        title,
        style:TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ) ,
      );
  }
}