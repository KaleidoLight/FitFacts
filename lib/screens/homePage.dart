import 'package:flutter/material.dart';
import 'package:fitfacts/navigation/navbar.dart';
import 'package:fitfacts/server/Impact.dart';
import 'package:fitfacts/server/NetworkUtils.dart';


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
            ElevatedButton(onPressed: (){Impact().authorize(context, "MMmxITaSML", "12345678!");}, child: Text('Authorize')),
            ElevatedButton(onPressed: () async{
              var result = await Impact().updateTokens();
              if (result != 200){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token Refresh Error')));
              }
              }, child: Text('Refresh Tokens'),),
            ElevatedButton(onPressed: () async {print( await TokenManager.accessToken());}, child: Text('Access Token')),
            ElevatedButton(onPressed: () async{
              final response = await Impact().getCalories();
              for (final day in response.data){
                print('DAY: ${day.date}  --  TOTAL CALORIES: ${day.totalCalories()} (kcal)');
              }
              print('WEEK AVERAGE: ${response.averageCaloriesWeek()} (kcal)');
              print('${response.day(6).date}\n${response.day(6).detail()}');
            }, child: Text('Calories')),
            ElevatedButton(onPressed: () async {
              final response = await Impact().getSteps();
              for (final day in response.data){
                print('DAY: ${day.date}  --  TOTAL STEPS: ${day.totalSteps()}');
              }
              print('WEEK AVERAGE: ${response.averageStepsWeek()}');
              print('WEEK TOTAL  : ${response.totalStepsWeek()}');
            }, child: Text('Get Steps')),
            ElevatedButton(onPressed: () async {
              final response = await Impact().getHeartRate();
              Map<String,double> data = response.day(6).fiveMinuteMean();
              data.forEach((key, value) {
                print('$key : $value (bpm)');
              });
            }, child: Text('Heart Rate')),
            ElevatedButton(onPressed: () async {
              final response = await Impact().getSleep();
              dynamic sleepData = response.day(1).sleepResume();
              print(sleepData);
              }, child: Text('Sleep')),
            ElevatedButton(onPressed: () async{
              final response = await Impact().getActivity();
              for (final activity in response.day(3).data){
                print(activity);
              }
            }, child: Text('Activity Data'))
          ],
        ),
      ),
      drawer: const Navbar(
        username: 'User',
      ),
    );
  } //build
} 