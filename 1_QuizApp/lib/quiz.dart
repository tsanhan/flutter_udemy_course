import 'package:flutter/material.dart';
import 'package:flutter_app/question.dart';

import 'answer.dart';

class Quiz extends StatelessWidget {
  
  final List<Map<String,Object>> questions;
  final Function answerQuestions;
  final int questionIndex;

  Quiz({@required this.questions, 
        @required this.answerQuestions,
        @required this.questionIndex});

  Widget build(BuildContext context) {
    return Column(
            children: <Widget>[
              Question(questions[questionIndex]['questionText']),
              ...(questions[questionIndex]['answers'] as List<Map<String,Object>>).map((answer) {
                return Answer(() => answerQuestions(answer['score']), answer['text']);
              }).toList(),
             
            ],
          );
  }
}