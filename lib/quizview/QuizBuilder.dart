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

  QuizData(this.data);

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
  num reference;
  Future<int>? personalRef;

  QuizActivity({required this.title, required this.topic ,required this.questions,required this.answer, required this.reference,this.link = ''});

}

class QuizQuestion {

  String body;
  bool   isCorrect;

  QuizQuestion({required this.body, this.isCorrect = false});

}