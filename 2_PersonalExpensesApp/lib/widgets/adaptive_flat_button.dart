import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Function presentDatePicker;
  final String text;
  AdaptiveFlatButton(this.presentDatePicker, this.text);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(text,
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: presentDatePicker)
        : FlatButton(
            child: Text(text,
                style: TextStyle(fontWeight: FontWeight.bold)),
            textColor: Theme.of(context).primaryColor,
            onPressed: presentDatePicker);
  }
}
