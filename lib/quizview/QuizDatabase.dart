import 'package:fitfacts/quizview/QuizBuilder.dart';

final quizDatabase = QuizData([
  QuizActivity(
      title: 'How many steps a day decrease the chance of cardio vascular diseases?',
      link: 'https://ijbnpa.biomedcentral.com/articles/10.1186/s12966-020-00978-9',
      topic: QuizTopic.heart,
      answer: 'Health benefits are present below 10,000 steps per day',
      reference: 7000,
      questions: [
        QuizQuestion(body: '10000'),
        QuizQuestion(body: '7000', isCorrect: true),
        QuizQuestion(body: '4000')
      ]),
  QuizActivity(
      title: 'What is the average heart STEP of an adult man at rest?',
      link: 'https://www.mayoclinic.org/healthy-lifestyle/fitness/expert-answers/heart-rate/faq-20057979',
      topic: QuizTopic.step,
      answer: 'The average heart rate at rest is between 60-100 bpm. Athletes may reach as low as 40 bpm at rest',
      reference: 60.0,
      questions: [
        QuizQuestion(body: '70-120 bpm'),
        QuizQuestion(body: '60-100 bpm', isCorrect: true),
        QuizQuestion(body: '45-90  bpm')
      ]),
]);
