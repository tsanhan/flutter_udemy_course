
import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  const Answer(this.selectHandler, this.text,  {Key key}) : super(key: key);
  final Function selectHandler;
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(text), 
          onPressed: selectHandler
          )
    );
  }
}