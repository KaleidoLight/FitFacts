import 'package:fitfacts/database/DatabaseRepo.dart';
import 'package:fitfacts/quizview/QuizBuilder.dart';
import 'package:intl/intl.dart';
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
        answer: 'VO2 Max is the maximum volume of oxygen consumed in ml/Kg/min',
        link: 'https://doi.org/10.1016/j.pcad.2017.03.002',
        unit: 'ml/kg/min',
        positive: 'Good Job! Your VO2Max is better than average',
        negative: 'Keep Working on your VO2Max',
        getReference: () async {
          final sex_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
          final age_raw = await Provider.of<DatabaseRepository>(context, listen: false).getBirthday();
          final weight_raw = await Provider.of<DatabaseRepository>(context, listen: false).getWeight();

          final sex = (sex_raw == 'Male') ? 0 : 13.7;
          final age = calculateStringAge(age_raw)! * 0.39;
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
        ),

    QuizActivity(
        title: 'What is the average RMR (resting metabolic rate) for someone like you?',
        topic: QuizTopic.calorie,
        questions: [
          QuizQuestion(body: '1600 - 2000 Kcal/day', isCorrect: true),
          QuizQuestion(body: '600 - 1200 Kcal/day'),
          QuizQuestion(body: '2000- 2500 Kcal/day')
        ],
        answer: 'RMR  normally ranges from 1,200 to 2,000 kcal/day (from 1,600 - 2000 kcal/day in men). Heavier people have higher RMR because they have more mass to support. Each pound of muscle burns to produce 6-7 kcal/day.',
        link: 'https://doi.org/10.5717/jenb.2014.18.1.25',
        unit: 'Kcal/day',
        positive: 'Your RMR is better than average',
        negative: 'Keep Working on your RMR',
        getReference: () async {
          final sex_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
          return (sex_raw == 'Male') ? 1800:1600;
        },
        getPersonalData: () async {
          final sex_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
          final age_raw = await Provider.of<DatabaseRepository>(context, listen: false).getBirthday();
          final weight_raw = await Provider.of<DatabaseRepository>(context, listen: false).getWeight();
          final height_raw = await Provider.of<DatabaseRepository>(context, listen: false).getHeight();


          final RMR = (sex_raw == 'Male') ? 66.473 + 5.003 * height_raw + 13.75 * weight_raw - 6.75 * calculateStringAge(age_raw)!:
          665.09 + 9.56 * height_raw + 1.84 * weight_raw - 4.67 * calculateStringAge(age_raw)!;

          return RMR;
        }
    ),

    QuizActivity(
        title: 'How many hours of sleep are considered fully restorative in adults ?',
        topic: QuizTopic.sleep,
        questions: [
          QuizQuestion(body: '5.5 - 7 hours', ),
          QuizQuestion(body: '7 - 8.5 hours', isCorrect: true),
          QuizQuestion(body: '8.5 - 10 hours')
        ],
        answer: 'In adults, sleep of 7 to 8.5 hours is considered fully restorative, although there is a wide variation among individuals.',
        link: 'https://www.researchgate.net/profile/Velayudhan-Kumar-2/publication/5241469_Sleep_and_sleep_disorders/links/00b4953b62a1fcc5f8000000/Sleep-and-sleep-disorders.pdf',
        unit: 'hours',
        positive: 'Your hours are better than average',
        negative: 'Try to sleep more!\nIt can help you to : get sick less often, stay at a healthy weight, lower your risk for serious health problems (like diabetes and heart disease) , reduce stress and improve your mood, think more clearly and do better at school and at work, get along better with people. \n',
        getReference: () async {
          return 7;
        },
        getPersonalData: () async {
          final sleep_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSleepData();

          /*List<num> sleep_array = [];
          sleep_raw.forEach((element) {
            if (element.speed > 0 && element.name == 'Corsa') {
              velocity_array.add(element.speed);
            }
          });
          num velocityMean = 0;
          velocity_array.forEach((element) {velocityMean += element;});
          return (velocityMean/velocity_array.length)/3.6;*/

          List<double> sleep_array = [];
          String sleepTime = '';
          sleep_raw.forEach((element) {sleepTime = element.duration;
          RegExp regex = RegExp(r'(\d+) hr, (\d+) min');
          Match? match = regex.firstMatch(sleepTime);
          String hours = '';
          String minutes = '';
          String tot_sleep = '';
          if (match != null) {
          // Extract hours and minutes as strings
          hours = match.group(1)!;
          minutes = match.group(2)!;
          tot_sleep = hours + '.' + minutes;
          } else {
            print('Invalid time string');
          }
          if (hours == '') {
            hours = '0';
            minutes = '0';
            tot_sleep = '0';
          }
          sleep_array.add(double.parse(tot_sleep));
          sleep_array[sleep_raw.indexOf(element)] = double.parse(tot_sleep);
          });

          num sleepMean = 0;
          sleep_array.forEach((element) {sleepMean += element;});
          return (sleepMean/sleep_array.length);

        }
    ),


/*    QuizActivity(
        title: 'What is the average RMR (resting metabolic rate) for women ?',
        topic: QuizTopic.calorie,
        questions: [
          QuizQuestion(body: '600 - 1200 Kcal/day'),
          QuizQuestion(body: '2000- 2500 Kcal/day'),
          QuizQuestion(body: '1200 - 1800 Kcal/day', isCorrect: true),
        ],
        answer: 'RMR normally ranges from 1,200 to 2,000 kcal/day (from 1,200 - 1800 kcal/day in women). Heavier people have higher RMR because they have more mass to support. Each pound of muscle burns to produce 6-7 kcal/day.',
        link: 'https://doi.org/10.5717/jenb.2014.18.1.25',
        unit: 'Kcal/day',
        positive: 'Your RMR is better than average',
        negative: 'Keep Working on your RMR',
        getReference: () async {
          final sex_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
          return (sex_raw == 'Male') ? 1800:1600;
        },
        getPersonalData: () async {
          final sex_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
          final age_raw = await Provider.of<DatabaseRepository>(context, listen: false).getBirthday();
          final weight_raw = await Provider.of<DatabaseRepository>(context, listen: false).getWeight();
          final height_raw = await Provider.of<DatabaseRepository>(context, listen: false).getHeight();


          final RMR = (sex_raw == 'Male') ? 66.473 + 5.003 * height_raw + 13.75 * weight_raw - 6.75 * calculateStringAge(age_raw):
          665.09 + 9.56 * height_raw + 1.84 * weight_raw - 4.67 * calculateStringAge(age_raw);

          return RMR;
        }
    ),*/

    QuizActivity(
        title: 'Which is the usual speed of an experienced runner (18-40yr)?',
        topic: QuizTopic.activity,
        questions: [
          QuizQuestion(body: '1-2 m/s'),
          QuizQuestion(body: '2-6 m/s', isCorrect: true),
          QuizQuestion(body: '6-8 m/s'),
        ],
        answer: 'Distance running speed may be said to range from 2 to 6 m/s',
        link: 'https://www.researchgate.net/profile/Rodger-Kram/publication/20480832_Stride_length_in_distance_running_velocity_body_dimensions_and_added_mass_effects/links/59df5ce90f7e9b2dba831716/Stride-length-in-distance-running-velocity-body-dimensions-and-added-mass-effects.pdf',
        unit: 'm/s',
        positive: 'Your medium velocity is better than a male experienced runner',
        negative: 'don \' t give up ! ',
        getReference: () async {
          return 2;
        },
        getPersonalData: () async {
          final activityData = await Provider.of<DatabaseRepository>(context, listen: false).getActivityData();
          List<num> velocity_array = [];
          activityData.forEach((element) {
            if (element.speed > 0 && element.name == 'Corsa') {
              velocity_array.add(element.speed);
            }
          });
          num velocityMean = 0;
          velocity_array.forEach((element) {velocityMean += element;});
          return (velocityMean/velocity_array.length)/3.6;
        }
    ),


    QuizActivity(
        title: 'Which is the common representation of BMI??',
        topic: QuizTopic.calorie,
        questions: [
          QuizQuestion(body: 'Index of intake calories'),
          QuizQuestion(body: 'Index of burnt calories'),
          QuizQuestion(body: 'Index of an individual’s fatness', isCorrect: true),
        ],
        answer: 'BMI represents an index of fatness. It is widely used as a risk factor for the development of several health issues.\nIn addition, it is widely used in determining public health policies.',
        link: 'https://doi.org/10.1097%2FNT.0000000000000092',
        unit: 'Kg/m^2',
        positive: '',
        negative: 'Your BMI is within range! ',
        getReference: () async {
          return 25;
        },
        getPersonalData: () async {

          final weight_raw = await Provider.of<DatabaseRepository>(context, listen: false).getWeight();
          final height_raw = await Provider.of<DatabaseRepository>(context, listen: false).getHeight()/100;

          return weight_raw/(height_raw * height_raw);
        }
    ),

    QuizActivity(
      title:
      'How many kilometers you should walk per day to stay healthy?',
      link:
      'https://www.verywellfit.com/set-pedometer-better-accuracy-3432895',
      unit: 'Km',
      topic: QuizTopic.step,
      answer: 'A research shows 5km is a good daily walking distance.\nThe step length can be calculated approximately as height(cm)*0.415',
      positive: 'Wonderful!, Yesterday you walked a longer distance ',
      negative: 'Come on! That\'s not such a long distance',
      getReference: () async {
        final sex_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
        final height = await Provider.of<DatabaseRepository>(context, listen: false).getHeight();
        final sex = (sex_raw == 'Male') ? 0.415 : 0.412;
        var distance = 7000*sex*height; //cm
        distance = distance.round()/100; //km
        return distance;
      },
      getPersonalData: () async {
        final stepsData = await Provider.of<DatabaseRepository>(context).getStepsData();
        final sex_raw = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
        final heigth = await Provider.of<DatabaseRepository>(context, listen: false).getHeight();
        final sex = (sex_raw == 'Male') ? 0.415 : 0.412;
        var distance = stepsData[0].steps*sex*heigth; //cm
        distance = distance.round()/100000; //km
        return distance;
      },
      questions: [
        QuizQuestion(body: '10 km'),
        QuizQuestion(body: '5 km', isCorrect: true),
        QuizQuestion(body: '8 km')
      ],
    ),

    QuizActivity(
        title: 'How much time of aerobic exercise reduces the risk of hypertension?',
        topic: QuizTopic.activity,
        questions: [
          QuizQuestion(body: '30 min/day (low intensity)', isCorrect: true),
          QuizQuestion(body: '10 hr/week of strength training'),
          QuizQuestion(body: '2 hr/week of HIT training')
        ],
        answer: '30 min of low intensity aerobic exercise per day will be enough',
        link: 'https://doi.org/10.1007/s11906-005-0026-z',
        unit: '',
        positive: 'Good Job! You are constant with your exercise',
        negative: 'you are not so active, let\'s start with some easy walk!',
        getReference: () async {
          return 6;
        },
        getPersonalData: () async {
          final activityDays = await Provider.of<DatabaseRepository>(context, listen: false).getActivityDays();
          return activityDays;
        }
    ),

    QuizActivity(
        title: 'Which sleep phase provides physical and mental benefits?',
        topic: QuizTopic.sleep,
        questions: [
          QuizQuestion(body: 'REM', ),
          QuizQuestion(body: 'Deep', isCorrect: true),
          QuizQuestion(body: 'Light')
        ],
        answer: 'During deep sleep, your body releases growth hormone and works to build and repair muscles, bones, and tissue. Deep sleep also promotes immune system functioning',
        link: 'https://www.sleepfoundation.org/stages-of-sleep/deep-sleep#:~:text=It%20usually%20takes%20between%2090,to%20six%20cycles%20per%20night.',
        unit: 'times',
        positive: 'This week you hit the right amount of deep sleep phases',
        negative: 'Try to sleep more! You need more sleep cycles to stay healthy',
        getReference: () async {
          return 4;
        },
        getPersonalData: () async {
          final sleepData = await Provider.of<DatabaseRepository>(context, listen: false).getSleepData();
          List<num> deep_sleepArray = [];
          sleepData.forEach((element) {
            print(element);
            if (element.deep_count > 0 ) {
              deep_sleepArray.add(element.deep_count);
            }
          });
          print(deep_sleepArray);
          num deepMean = 0;
          deep_sleepArray.forEach((element) {deepMean += element;});
          return deepMean/deep_sleepArray.length;

        }
    ),


    QuizActivity(
        title: 'What is the appropriate average heart beat of an healthy person',
        topic: QuizTopic.heart,
        questions: [
          QuizQuestion(body: '90-100 bpm', ),
          QuizQuestion(body: '40-50 bpm',),
          QuizQuestion(body: '60-80 bpm', isCorrect: true)
        ],
        answer: '60-80 bpm, higher heart rate can be symptom of stress or some disease',
        link: 'https://www.whoop.com/thelocker/resting-heart-rate-by-age-and-gender/',
        unit: 'bpm',
        //here is the contrary
        positive: 'Your average bpm is high, consider talking about it to a doctor',
        negative: 'Great! You have an healthy heart rate',
        getReference: () async {
          return 80;
        },
        getPersonalData: () async {
          List<int> avg_bpm = [];
          int effective_day = 1;
          for (var day_subtract = 1; day_subtract < 8; day_subtract++) {

            final heartData = await Provider.of<DatabaseRepository>(context, listen: false).getHeartDataOfDay(DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: day_subtract))));
            double dayBPM = 0.1;
            int dayCounts = 0;
            heartData.forEach((element) {
              dayBPM = dayBPM + element.beats;
              dayCounts = dayCounts + 1;
            });

            try {
              avg_bpm.add((dayBPM / dayCounts ).round());
              effective_day = effective_day + 1;
            } catch (error) {
              avg_bpm[day_subtract] = 0;
            }

          }
          int sum_hr = 0;
          avg_bpm.forEach((element) {
            sum_hr = sum_hr + element;
          });
          return (sum_hr/effective_day - 1).round();
        }
    ),

  ]);
}




