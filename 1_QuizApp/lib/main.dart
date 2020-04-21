import 'package:flutter/material.dart';
import 'package:flutter_app/quiz.dart';
import 'package:flutter_app/result.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;

  final _questions = const [
       {
        'questionText':"What's your favorite color?",
        'answers': [
          {'text':'black','score':10},
          {'text':'red','score':5},
          {'text':'green','score':3},
          {'text':'white','score':1}
        ]
      },
      {
        'questionText':"What's your favorite animal?",
        'answers': [
          {'text':'Rabbit','score':3},
          {'text':'Snake','score':11},
          {'text':'Elephant','score':5},
          {'text':'Lion','score':9}
        ]
        },
        {
        'questionText':"What's your favorite instructor?",
        'answers': [
          {'text':'Max','score':1},
          {'text':'Max','score':1},
          {'text':'Max','score':1},
          {'text':'Max','score':1}
        ]
        },      
      ];
  
  void _resetQuiz() {  
        setState(() {
          _questionIndex = 0;
          _totalScore = 0;
        });
      }
  void _answerQuestions(int score){
    
    _totalScore += score;

    setState(() {
      _questionIndex++;
    }); 
    
   
    print(_questionIndex);
    if (_questionIndex < _questions.length) {
      print("we have more questions");
    } else {
      print("no more questions!");

    }
  }

  @override
  Widget build(BuildContext context) {
     

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("My First App"),
          ),
          body: _questionIndex < _questions.length ?
           Quiz(answerQuestions: _answerQuestions, 
                questionIndex: _questionIndex, 
                questions: _questions
              ) : 
           Result(result: _totalScore, reset: _resetQuiz)
          ),
    );
  }
}
