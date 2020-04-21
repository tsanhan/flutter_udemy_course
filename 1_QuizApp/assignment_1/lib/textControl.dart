import 'package:flutter/material.dart';
import './text.dart';

class TextControl extends StatelessWidget {
  final Function changeTextFunc;

  TextControl({this.changeTextFunc});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
            child: TextWidget(text: "change to Hi there",),
            onPressed: changeTextFunc,
      );
  }
}