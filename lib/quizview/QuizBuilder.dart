import 'dart:math';

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
    data.forEach((quiz) {
      if (quiz.topic == forTopic) {
        result.add(quiz);
      }
    });

    final random = Random();
    int randomIndex = random.nextInt(result.length);
    return result[randomIndex];
  }

}

class QuizActivity{

  String title;
  QuizTopic topic;
  String link;
  List<QuizQuestion> questions;
  String answer;
  String positive;
  String negative;
  num reference;
  String unit;
  Future<num>? personalRef;

  QuizActivity({required this.title,
    required this.topic ,
    required this.questions,
    required this.answer,
    required this.positive,
    required this.negative,
    required this.reference,
    this.unit = '',
    this.link = '',
    required Future<num> Function() getPersonalData}) : personalRef = getPersonalData();

}

class QuizQuestion {

  String body;
  bool   isCorrect;

  QuizQuestion({required this.body, this.isCorrect = false});

}