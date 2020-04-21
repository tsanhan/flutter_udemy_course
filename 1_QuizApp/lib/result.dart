import 'package:flutter/material.dart';

class Result extends StatelessWidget {

  final int result;
  final Function reset;
  Result({this.result, this.reset});

  String get resultPrase{
    String  resultText;

    if(result <= 8)
      resultText = "you are awsome and innocent";
      else if (result <= 12) {
        resultText = "pretty likeable!";
      }
       else if (result <= 16) {
        resultText = "you are... strange!";
      }else{
        resultText = "you are... so bed";
      }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
            child:  Text(resultPrase,
            style:  TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
        ),
        FlatButton(
        child: Text('Restart Quiz'), 
        onPressed: reset,
        textColor: Colors.blue,
        )
      ],
    );
  }
}