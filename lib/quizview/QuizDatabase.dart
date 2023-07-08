import 'package:fitfacts/database/DatabaseRepo.dart';
import 'package:fitfacts/quizview/QuizBuilder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fitfacts/screens/profilePage.dart';

QuizData createQuizDatabase(BuildContext context) {
  return QuizData(data: [
    QuizActivity(
        title:
            'How many steps a day decrease the chance of cardiovascular diseases?',
        link:
            'https://ijbnpa.biomedcentral.com/articles/10.1186/s12966-020-00978-9',
        topic: QuizTopic.step,
        answer: 'Health benefits are present above 7000 steps per day',
        positive: 'Wonderful!, Yesterday you did better than average with',
        negative: 'Don\'t give up! This week you did ',
        getReference: () async {return 7000;},
        unit: 'steps', getPersonalData: () async {
      final stepsData =
          await Provider.of<DatabaseRepository>(context).getStepsData();
      print(
          'STEPS DATA FOUND: ${stepsData.last.date} - ${stepsData.last.steps}');
      return stepsData[0].steps;
    },
        questions: [
          QuizQuestion(body: '10000'),
          QuizQuestion(body: '7000', isCorrect: true),
          QuizQuestion(body: '4000')
        ],
    ),
    QuizActivity(
        title: 'Which physiological meaning VO2Max has in fitness?',
        topic: QuizTopic.activity,
        questions: [
          QuizQuestion(body: 'Maximum Volume of O2 consumed', isCorrect: true),
          QuizQuestion(body: 'Maximum lungs capacity'),
          QuizQuestion(body: 'Maximum Respiration Rate')
        ],
        answer: 'VO2 Max is the maximum volume of oxigen consumed in ml/Kg/min',
        link: 'https://doi.org/10.1016/j.pcad.2017.03.002',
        unit: 'ml/kg/min',
        positive: 'Good Job! Your VO2Max is better than average',
        negative: 'Keep Working on your VO2Max',
        getReference: () async {
          final sex_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
          final age_raw = await Provider.of<DatabaseRepository>(context, listen: false).getBirthday();
          final weight_raw = await Provider.of<DatabaseRepository>(context, listen: false).getWeight();

          final sex = (sex_raw == 'Male') ? 0 : 13.7;
          final age = calculateStringAge(age_raw) * 0.39;
          final weight = weight_raw * 0.127 * 2.2;

          return 79.9 - age - sex - weight;
        },
        getPersonalData: () async {
          final activityData = await Provider.of<DatabaseRepository>(context, listen: false).getActivityData();
          List<num> vo2maxArray = [];
          activityData.forEach((element) {
            if (element.vo2max > 0 ) {
              vo2maxArray.add(element.vo2max);
            }
          });

          num vo2Mean = 0;
          vo2maxArray.forEach((element) {vo2Mean += element;});
          return vo2Mean/vo2maxArray.length;
        }
        )
  ]);
}
