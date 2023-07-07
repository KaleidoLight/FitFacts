import 'package:fitfacts/database/ActivityData.dart';
import 'package:fitfacts/database/CalorieData.dart';
import 'package:fitfacts/database/HeartData.dart';
import 'package:fitfacts/database/SleepData.dart';
import 'package:fitfacts/database/StepsData.dart';
import 'package:fitfacts/database/UserInfo.dart';
import 'Database.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier{
  final AppDatabase database;

  DatabaseRepository({required this.database});

  /// USER INFO
  ///
  Future<UserInfo> findUser() async {
    final result = await database.userInfoDao.findAllUsers();
    return result.first;
  }

  Future<String> getUsername() async {
    final result = await findUser();
    return result.username;
  }

  Future<String> getBirthday() async {
    final result = await findUser();
    return result.birthDay;
  }

  Future<String> getSex() async {
    final result = await findUser();
    return result.sex;
  }

  Future<int> getHeight() async {
    final result = await findUser();
    return result.height;
  }

  Future<int> getWeight() async {
    final result = await findUser();
    return result.weight;
  }

  Future<int> getCalorieGoal() async {
    final result = await findUser();
    return result.calorieGoal;
  }

  Future<int> getStepGoal() async {
    final result = await findUser();
    return result.stepGoal;
  }

  Future<int> getSmartStars() async {
    final result = await findUser();
    return result.smartStars;
  }

  Future<dynamic>? queryUserInfo(String fromString){
    if (fromString == 'Username'){
      return getUsername();
    } else if (fromString == 'Birthday'){
      return getBirthday();
    } else if (fromString == 'CalorieGoal') {
      return getCalorieGoal();
    }
    else if (fromString == 'StepGoal'){
      return getStepGoal();
    }
    else if (fromString == 'Weight'){
      return getWeight();
    }
    else if (fromString == 'Height'){
      return getHeight();
    }
    return null;
  }

  Future<void> registerUser(UserInfo withInfo) async {
    try {
      await deleteUser(await findUser());
      await database.userInfoDao.registerUser(withInfo);
    } catch (error){
      print(error);
      await database.userInfoDao.registerUser(withInfo);
    }
    notifyListeners();
  }

  Future<void> updateUserInfo(void Function(UserInfo) callback) async {
    try {
      UserInfo myObject = await findUser();
      callback(myObject);
      await database.userInfoDao.updateUser(myObject);
    }catch(error){
      print('Error Updating Database Entry: $error');
    }
    notifyListeners();
  }

  Future<void> deleteUser(UserInfo withInfo) async {
    await database.userInfoDao.deleteUser(withInfo);
    notifyListeners();
  }

  // CalorieData

  Future<List<CalorieData>> getCalorieData() async {
    final result = await database.calorieDataDao.findCalorieData();
    return result;
  }

  Future<List<CalorieData>> getCalorieDataOfDay(int dayRef) async {
    final result = await database.calorieDataDao.findCalorieDataOfDay(dayRef);
    return result;
  }

  Future<List<CalorieDetail>> getCalorieDetail() async {
    final result = await database.calorieDataDao.findCalorieDetail();
    return result;
  }

  Future<void> addCalorieData(CalorieData withInfo) async {
    await database.calorieDataDao.addCalorieData(withInfo);
  }

  Future<void> addCalorieDetail(CalorieDetail withInfo) async {
    await database.calorieDataDao.addCalorieDetail(withInfo);
  }

  Future<void> updateCalorieData(CalorieData withInfo) async {
    await database.calorieDataDao.updateCalorieData(withInfo);
    notifyListeners();
  }

  Future<void> updateCalorieDetail(CalorieDetail withInfo) async {
    await database.calorieDataDao.updateCalorieDetail(withInfo);
    notifyListeners();
  }

  Future<void> deleteCalorieDetail(CalorieDetail withInfo) async {
    await database.calorieDataDao.deleteCalorieDetail(withInfo);
    notifyListeners();
  }

  // StepsData

  Future<List<StepsData>> getStepsData() async {
    final result = await database.stepsDataDao.findStepsData();
    return result;
  }

  Future<List<StepsData>> getStepsDataOfDay(int dayRef) async {
    final result = await database.stepsDataDao.findStepsDataOfDay(dayRef);
    return result;
  }

  Future<List<StepsDetail>> getStepsDetail() async {
    final result = await database.stepsDataDao.findStepsDetail();
    return result;
  }

  Future<void> addStepsData(StepsData withInfo) async {
    await database.stepsDataDao.addStepsData(withInfo);
  }

  Future<void> addStepsDetail(StepsDetail withInfo) async {
    await database.stepsDataDao.addStepsDetail(withInfo);
  }

  Future<void> updateStepsData(StepsData withInfo) async {
    await database.stepsDataDao.updateStepsData(withInfo);
    notifyListeners();
  }

  Future<void> updateStepsDetail(StepsDetail withInfo) async {
    await database.stepsDataDao.updateStepsDetail(withInfo);
    notifyListeners();
  }

  Future<void> deleteStepsData(StepsData withInfo) async {
    await database.stepsDataDao.deleteStepsData(withInfo);
    notifyListeners();
  }

  Future<void> deleteStepsDetail(StepsDetail withInfo) async {
    await database.stepsDataDao.deleteStepsDetail(withInfo);
    notifyListeners();
  }

  // Heart Data

  Future<List<HeartData>> getHeartData() async {
    final result = await database.heartDataDao.findHeartData();
    return result;
  }



  Future<List<HeartData>> getHeartDataOfDay(String date) async {
    final result = await database.heartDataDao.findHeartDataOfDay(date);
    return result;
  }

  Future<void> addHeartData(HeartData withInfo) async {
    await database.heartDataDao.addHeartData(withInfo);
  }

  Future<void> updateHeartData(HeartData withInfo) async {
    await database.heartDataDao.updateHeartData(withInfo);
  }

  Future<void> deleteHeartData(HeartData withInfo) async {
    await database.heartDataDao.deleteHeartData(withInfo);
  }

  // SleepData

  Future<List<SleepData>> getSleepData() async {
    final result = await database.sleepDataDao.findSleepData();
    return result;
  }

  Future<List<SleepData>> getSleepDataOfDay(String date) async {
    final result = await database.sleepDataDao.findSleepDataOfDay(date);
    return result;
  }

  Future<void> addSleepData(SleepData withInfo) async {
    await database.sleepDataDao.addSleepData(withInfo);
  }

  Future<void> updateSleepData(SleepData withInfo) async {
    await database.sleepDataDao.updateSleepData(withInfo);
  }

  Future<void> deleteSleepData(SleepData withInfo) async {
    await database.sleepDataDao.deleteSleepData(withInfo);
  }

  // Activity Data

  Future<List<ActivityData>> getActivityData() async {
    final result = await database.activityDataDao.findActivityData();
    return result;
  }

  Future<List<ActivityData>> getActivityDataOfDay(String date) async {
    final result = await database.activityDataDao.findActivityDataOfDay(date);
    return result;
  }

  Future<int> getActivityDays() async {
    final result = await database.activityDataDao.findActivityDaysOnWeek() ?? 0;
    return result;
  }

  Future<void> addActivityData(ActivityData withInfo) async {
    await database.activityDataDao.addActivityData(withInfo);
  }

  Future<void> updateActivityData(ActivityData withInfo) async {
    await database.activityDataDao.updateActivityData(withInfo);
  }

  Future<void> deleteActivityData(ActivityData withInfo) async {
    await database.activityDataDao.deleteActivityData(withInfo);
  }

  //DATA WIPE

  Future<void> wipeDatabase() async {
    await database.activityDataDao.wipeData();
    await database.calorieDataDao.wipeData();
    await database.calorieDataDao.wipeDetail();
    await database.heartDataDao.wipeData();
    await database.sleepDataDao.wipeData();
    await database.stepsDataDao.wipeData();
    await database.stepsDataDao.wipeDetail();
    await database.userInfoDao.wipeData();
  }

}