import 'dart:math';
import 'QuizView.dart';

enum QuizTopic {
  step,
  calorie,
  sleep,
  heart,
  activity
}

class QuizData {

  List<QuizActivity> data;

  QuizData({required this.data});

  QuizActivity getQuiz(QuizTopic forTopic){
    List<QuizActivity> result = [];
    for (var quiz in data) {
      if (quiz.topic == forTopic) {
        result.add(quiz);
      }
    }

    final random = Random();
    int randomIndex = random.nextInt(result.length);
    return result[randomIndex];
  }

}

class QuizActivity{

  String title; // question title
  QuizTopic topic; // the topic related
  String link; // link to the paper
  List<QuizQuestion> questions; // possible choices
  String answer; // string answer
  String positive; // outcome if positive
  String negative; // outcome if negative
  Future<num> reference; // decision threshold
  String unit; // unit of measure
  Future<num>? personalRef; // personal health metric (from the database -> future)
  Roundings roundType;

  QuizActivity({required this.title,
    required this.topic ,
    required this.questions,
    required this.answer,
    required this.positive,
    required this.negative,
    this.unit = '',
    this.link = '',
    this.roundType = Roundings.decimals,
    required Future<num> Function() getPersonalData,
    required Future<num> Function() getReference
  }) : personalRef = getPersonalData(), reference = getReference();

}

class QuizQuestion {

  String body;
  bool   isCorrect;

  QuizQuestion({required this.body, this.isCorrect = false});

}