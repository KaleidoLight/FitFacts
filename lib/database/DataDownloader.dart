import 'package:fitfacts/server/Impact.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:fitfacts/database/ActivityData.dart';
import 'package:fitfacts/database/CalorieData.dart';
import 'package:fitfacts/database/HeartData.dart';
import 'package:fitfacts/database/SleepData.dart';
import 'package:fitfacts/database/StepsData.dart';

import 'DatabaseRepo.dart';

Future<void> downloadAndStoreData(BuildContext context) async {

  // Calories Download and Storing
  final caloriesAPIResponse = await Impact().getCalories();
  for (int day = 1; day <= 7; day++) {
    if (caloriesAPIResponse.data.isNotEmpty) {
      Provider.of<DatabaseRepository>(context, listen: false).addCalorieData(
          CalorieData(day, caloriesAPIResponse
              .day(day)
              .date, caloriesAPIResponse.day(day).totalCalories())
      );
    }else {
      print('No Calories Data for time-range');
    }
  }

  final lastCalorieDay = caloriesAPIResponse.day(7).detail();
  lastCalorieDay.forEach((hour, calorie) {
    Provider.of<DatabaseRepository>(context, listen: false).addCalorieDetail(CalorieDetail(hour, calorie));
  });

  // Steps Download and Storing
  final stepsAPIResponse = await Impact().getSteps();
  for (int day = 1; day <= 7; day++) {
    if (stepsAPIResponse.data.isNotEmpty) {
      Provider.of<DatabaseRepository>(context, listen: false).addStepsData(
          StepsData(day, stepsAPIResponse
              .day(day)
              .date, stepsAPIResponse.day(day).totalSteps())
      );
    } else {
      print('No Steps Data for time-range');
    }
  }
  final lastStepsDay = stepsAPIResponse.day(7).detail();
  lastStepsDay.forEach((hour, steps) {
    Provider.of<DatabaseRepository>(context, listen: false).addStepsDetail(StepsDetail(hour, steps));
  });


  // HeartRate Download and Storing
  final heartAPIResponse = await Impact().getHeartRate();
  int dayReference = 0;
  for (int day = 1; day <= 7; day++) {
    if (heartAPIResponse.data.isNotEmpty) {
      final dayDetail = heartAPIResponse.day(day);
      if (dayDetail.data.isNotEmpty) {
        final dayDate = dayDetail.date;
        final dayLog = dayDetail.fiveMinuteMean();
        dayLog.forEach((logTime, heartBeat) {
          Provider.of<DatabaseRepository>(context, listen: false).addHeartData(
              HeartData(dayReference, dayDate, logTime, heartBeat)
          );
          dayReference += 1;
        });
      }else {
        print('No Heart data for Day');
      }
    } else {
      print('No heart data for selected time range');
    }
  }
  // SleepData Download and Storing
  final sleepAPIResponse = await Impact().getSleep();
  for(int day = 1; day <= 7; day++){
    if (sleepAPIResponse.data.isNotEmpty) {
      final sleepDay = sleepAPIResponse.day(day);
      if (sleepDay.data.isNotEmpty) {
        final sleepResume = sleepDay.sleepResume();
        Provider.of<DatabaseRepository>(context, listen: false).addSleepData(SleepData(
            dayReference: day,
            start_day: sleepResume.startDate,
            end_day: sleepResume.endDate,
            duration: sleepResume.duration,
            wake_count: sleepResume.levels['wake']?.count ?? 0,
            wake_minutes: sleepResume.levels['wake']?.minutes ?? 0,
            light_count: sleepResume.levels['light']?.count ?? 0,
            light_minutes: sleepResume.levels['light']?.minutes ?? 0,
            rem_count: sleepResume.levels['rem']?.count ?? 0,
            rem_minutes: sleepResume.levels['rem']?.minutes ?? 0,
            deep_count: sleepResume.levels['deep']?.count ?? 0,
            deep_minutes: sleepResume.levels['deep']?.minutes ?? 0));
      } else {
        print('No sleep data available for the selected day.');
      }
    } else {
      print('No sleep data available for the specified date range.');
    }
  }

  // ActivityData

  final activityAPIResponse = await Impact().getActivity();
  int activityReference = 0;
  for(int day = 1; day <= 7; day++){
    if(activityAPIResponse.data.isNotEmpty){
      final dailyActivities = activityAPIResponse.day(day);
      if (dailyActivities.data.isNotEmpty) {
        dailyActivities.data.forEach((activity) {
          Provider.of<DatabaseRepository>(context, listen: false).addActivityData(ActivityData(
              activityReference: activityReference,
              name: activity.activityName,
              date: dailyActivities.date,
              avgHR: activity.averageHeartRate.toDouble(),
              vo2max: activity.vo2Max.vo2Max.toDouble(),
              calories: activity.calories.toDouble(),
              distance: activity.distance.toDouble(),
              distanceUnit: activity.distanceUnit,
              duration: activity.duration.toDouble(),
              activeDuration: activity.activeDuration.toDouble(),
              speed: activity.speed.toDouble(),
              pace: activity.pace,
              hl1_range: '${activity.heartRateZones[0].min} - ${activity.heartRateZones[0].max} bpm',
              hl1_time: activity.heartRateZones[0].minutes.toDouble(),
              hl2_range: '${activity.heartRateZones[1].min} - ${activity.heartRateZones[1].max} bpm',
              hl2_time: activity.heartRateZones[1].minutes.toDouble(),
              hl3_range: '${activity.heartRateZones[2].min} - ${activity.heartRateZones[2].max} bpm',
              hl3_time: activity.heartRateZones[2].minutes.toDouble(),
              hl4_range: '${activity.heartRateZones[3].min} - ${activity.heartRateZones[3].max} bpm',
              hl4_time: activity.heartRateZones[3].minutes.toDouble()));
        });
        activityReference += 1;
      }else{
        print('No Activities for this Day');
      }
    } else {
      print('No Activities for this time range');
    }
  }

}