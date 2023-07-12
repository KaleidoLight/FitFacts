import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:fitfacts/database/UserInfo.dart';
import 'package:fitfacts/database/CalorieData.dart';
import 'package:fitfacts/database/StepsData.dart';
import 'package:fitfacts/database/HeartData.dart';
import 'package:fitfacts/database/SleepData.dart';
import 'package:fitfacts/database/ActivityData.dart';

part 'Database.g.dart';

@Database(version: 1, entities: [
  UserInfo,
  CalorieData,
  CalorieDetail,
  StepsData,
  StepsDetail,
  HeartData,
  SleepData,
  ActivityData,
])

abstract class AppDatabase extends FloorDatabase {
  UserInfoDao get userInfoDao; // User Info Getter
  CalorieDataDao get calorieDataDao; // Calorie Day Data Getter
  StepsDataDao get stepsDataDao; // Steps Data Getter
  HeartDataDao get heartDataDao; // Heart Data Getter
  SleepDataDao get sleepDataDao; // Sleep Data Getter
  ActivityDataDao get activityDataDao; // Activity Data Getter
}
