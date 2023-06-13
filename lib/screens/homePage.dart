import 'package:fitfacts/database/CalorieData.dart';
import 'package:fitfacts/database/DataDownloader.dart';
import 'package:fitfacts/database/HeartData.dart';
import 'package:fitfacts/database/SleepData.dart';
import 'package:fitfacts/database/StepsData.dart';
import 'package:fitfacts/database/DatabaseRepo.dart';
import 'package:flutter/material.dart';
import 'package:fitfacts/navigation/navbar.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitFacts'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('HomePage coming Soon'),
            ElevatedButton(onPressed: () async {
              final calorieData = await Provider.of<DatabaseRepository>(context, listen: false).getCalorieData();
              printCalorieTable(calorieData);
            }, child: Text('Print Calories')),
            ElevatedButton(onPressed: () async {
              final calorieData = await Provider.of<DatabaseRepository>(context, listen: false).getCalorieDetail();
              printCalorieDetail(calorieData);
            }, child: Text('Print Calories Detail')),
            ElevatedButton(onPressed: () async {
              final stepsData = await Provider.of<DatabaseRepository>(context, listen: false).getStepsData();
              printStepsTable(stepsData);
            }, child: Text('Print Steps')),
            ElevatedButton(onPressed: () async {
              final stepsDetail = await Provider.of<DatabaseRepository>(context, listen: false).getStepsDetail();
              printStepsDetail(stepsDetail);
            }, child: Text('Print Step Detail')),
            ElevatedButton(onPressed: () async {
              final heartFull = await Provider.of<DatabaseRepository>(context, listen: false).getHeartData();
              printHeartTable(heartFull);
            }, child: Text('Print Heart Full')),
            ElevatedButton(onPressed: () async {
              final heartDay = await Provider.of<DatabaseRepository>(context, listen: false).getHeartDataOfDay('2023-05-31');
              printHeartTable(heartDay);
            }, child: Text('Print Heart Day')),
            ElevatedButton(onPressed: () async {
              final sleepFull = await Provider.of<DatabaseRepository>(context, listen: false).getSleepData();
              printSleepTable(sleepFull);
            }, child: Text('Print Sleep Full')),
            ElevatedButton(onPressed: () async {
              final sleepDay = await Provider.of<DatabaseRepository>(context, listen: false).getSleepDataOfDay('2023-05-31');
              printSleepTable(sleepDay);
            }, child: Text('Print Sleep Day')),
            ElevatedButton(onPressed: () async {
              final activityData = await Provider.of<DatabaseRepository>(context, listen: false).getActivityData();
              activityData.forEach((element) {
                print('${element.activityReference}\t${element.name}\t\t${element.date}');
              });
            }, child: Text('Activity Data')),
            ElevatedButton(onPressed: () async
            {
              await Provider.of<DatabaseRepository>(context, listen: false).wipeDatabase();
            }, child: Text('Wipe Database')),
            ElevatedButton(onPressed: () async
            {
              await downloadAndStoreData(context);
            }, child: Text('Populate Database')),
            ElevatedButton(onPressed: () async {
              await Provider.of<DatabaseRepository>(context, listen: false).updateUserInfo((info) {
                info.smartStars += 5;
              });
            }, child: Text('Add Coins'))
          ]
        ),
      ),
      drawer: const Navbar(
        username: 'User',
      ),
    );
  } //build
} 