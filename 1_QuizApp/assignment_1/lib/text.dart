import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {

  final text;
  TextWidget({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}