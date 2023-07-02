import 'package:fitfacts/database/DatabaseRepo.dart';
import 'package:fitfacts/quizview/QuizBuilder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

QuizData createQuizDatabase(BuildContext context) {
  return QuizData(data: [
    QuizActivity(
      title:
          'How many steps a day decrease the chance of cardiovascular diseases?',
      link:
          'https://ijbnpa.biomedcentral.com/articles/10.1186/s12966-020-00978-9',
      topic: QuizTopic.heart,
      answer: 'Health benefits are present above 7000 steps per day',
      positive: 'Wonderful!, Yesterday you did better than average with',
      negative: 'Don\'t give up! This week you did ',
      reference: 7000,
      unit: 'steps',
      getPersonalData: () async {
        final stepsData =
            await Provider.of<DatabaseRepository>(context).getStepsData();
        print('STEPS DATA FOUND: ${stepsData.last.date} - ${stepsData.last.steps}');
        return stepsData[0].steps;
      },
      questions: [
        QuizQuestion(body: '10000'),
        QuizQuestion(body: '7000', isCorrect: true),
        QuizQuestion(body: '4000')
      ],
    )
  ]);
}
