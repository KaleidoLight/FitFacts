import 'package:fitfacts/database/CalorieData.dart';
import 'package:fitfacts/database/DatabaseRepo.dart';
import 'package:fitfacts/database/HeartData.dart';
import 'package:fitfacts/database/SleepData.dart';
import 'package:fitfacts/database/StepsData.dart';
import 'package:flutter/material.dart';
import 'package:fitfacts/navigation/navbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fitfacts/themes/blocks.dart';
import '../themes/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {

    var themeMode = context.watch<ThemeModel>().mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.deepPurple[50] : Colors.black;

    print('${HomePage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitFacts'),
      ),
      body: Body(),
      backgroundColor: bkColor,
      drawer: const Navbar(),
      onDrawerChanged: (isOpened){
        if(!isOpened){
          Provider.of<DatabaseRepository>(context, listen: false).updateView();
        }
      },
    );
  } }

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {

    return ListView(
      children: <Widget>[
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(height: 60,),
                  Text(
                    DateFormat('EEEE, d MMMM').format(DateTime.now().subtract(const Duration(days: 1))),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(height: 40,),
                  const Text('Your Health Dashboard', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                ],
              ),
            ),
            Container(height: 15,),
            const ActivityView(),
            Row(
              children: const [
                HeartBeatView(),
                StepsView()
              ],
            ),
            Row(
              children: const [
                CalorieView(),
                SleepView()
              ],
            ),
          ],
        )
      ],
    );
  }
}

// Activity View
class ActivityView extends StatelessWidget {

  const ActivityView({Key? key}) : super(key: key);

  @override
  build(BuildContext context)  {
    var size = MediaQuery.of(context).size;
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[350] : Colors.grey[700];
    return LargeBlock(
        title: 'Weekly Activity',
        icon: Icons.sports,
        body: Consumer<DatabaseRepository>(
          builder: (context, dbr, child){
            return FutureBuilder(
                initialData: 0,
                future: Provider.of<DatabaseRepository>(context).getActivityDays(),
                builder: (context, snapshot){
                if (snapshot.hasData){
                  final activityDays = snapshot.data as int;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text('$activityDays', style: const TextStyle(fontSize: 80)),
                              Container(width: 5,),
                              const Text('/7', style: TextStyle(fontSize: 30),)
                            ],),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child:  Text('Days of activity', style: TextStyle(fontSize: 18),),
                            )
                          ]),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 60,
                              lineWidth: size.width/30,
                              animation: true,
                              percent: activityDays/7,
                              center: Text(
                                "${(activityDays/7*100).round()}%",
                                style:
                                const TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.grey),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Theme.of(context).primaryColor,
                              backgroundColor: greyColor!,
                            ),
                          ],
                        ),
                      ),
                    ],);
                }else{
                  return Container();
                }
                });
          },
        )
    );
  }
}

// HeartBeat View
class HeartBeatView extends StatelessWidget {
  const HeartBeatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmallBlock(title: 'Heart Beat', icon: Icons.favorite,
        body:Consumer<DatabaseRepository>(
          builder: (context, dbr, child){
            return FutureBuilder(
                future: Provider.of<DatabaseRepository>(context).getHeartData(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    final dayHeart = snapshot.data as List<HeartData>;
                    double dayBPM = 0.1;
                    int dayCounts = 0;
                    for (var element in dayHeart) {
                      if (element.date == DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)))){
                        dayBPM = dayBPM + element.beats;
                        dayCounts = dayCounts + 1;
                      }
                    }
                    int avgBPM = 0;
                    try {
                      avgBPM = (dayBPM / dayCounts).round();
                    } catch(error){
                      avgBPM = 0;
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('$avgBPM', style: const TextStyle(fontSize: 70)),
                            Container(width: 5,),
                            const Text('BPM', style: TextStyle(fontSize: 20),)
                          ],),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child:  Text('Daily Average Measurement', style: TextStyle(fontSize: 15),),
                        )
                      ],);
                  }else{
                    return Container();
                  }
                });
          },
        )
    );
  }
}

// Steps View
class StepsView extends StatelessWidget {
  const StepsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[350] : Colors.grey[700];
    return SmallBlock(
        title: 'Daily Steps',
        icon: Icons.directions_walk_rounded,
        body: Consumer<DatabaseRepository>(
          builder: (context, dbr, child){
            return FutureBuilder(
                future: Future.wait([Provider.of<DatabaseRepository>(context).getStepsData(), Provider.of<DatabaseRepository>(context).getStepGoal()]),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    final List<Object> data = snapshot.data!;
                    final stepsData = data[0] as List<StepsData>;
                    final stepGoal = data[1] as int;
                    int dailySteps = 0;
                    for (var element in stepsData) {
                      if (element.date == DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)))){
                        dailySteps = element.steps;
                      }
                    }
                    double stepPercentage = 0;
                    try {
                      stepPercentage = dailySteps / stepGoal;
                    }catch(error) {
                      print(error);
                    };
                    if (stepPercentage > 1 || stepPercentage.isInfinite){
                      stepPercentage = 1;
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircularPercentIndicator(
                          radius: 45,
                          lineWidth: size.width/30,
                          animation: true,
                          percent: stepPercentage,
                          center: Text(
                            "${(stepPercentage*100).round()}%",
                            style:
                            const TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Theme.of(context).primaryColor,
                          backgroundColor: greyColor!,
                        ),
                        Container(height: 15,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Row(
                            children: [
                              Text('$dailySteps', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                              const Text(' steps', style: TextStyle(fontSize: 20),)
                            ],
                          ),
                        )
                      ],);
                  }else{
                    return Container();
                  }
                });
          },
        )
    );
  }
}

// Calorie View
class CalorieView extends StatelessWidget {
  const CalorieView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[350] : Colors.grey[700];
    return SmallBlock(
        title: 'Daily Calories',
        icon: Icons.local_fire_department_rounded,
        body:
        Consumer<DatabaseRepository>(
          builder: (context, dbr, child){
            return FutureBuilder(
                future: Future.wait([
                  Provider.of<DatabaseRepository>(context).getCalorieData(),
                  Provider.of<DatabaseRepository>(context).getCalorieGoal()
                ]),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    final List<Object> data = snapshot.data!;
                    final calorieData = data[0] as List<CalorieData>;
                    final calorieGoal = data[1] as int;
                    int dayCalorie = 0;
                    for (var element in calorieData) {
                      if (element.date == DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)))){
                        dayCalorie = element.calorie;
                      }
                    }
                    double caloriePercentage = 0;
                    try {
                      caloriePercentage = dayCalorie / calorieGoal;
                    }catch(error){print(error);}
                    if (caloriePercentage > 1 || caloriePercentage.isInfinite){
                      caloriePercentage = 1;
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircularPercentIndicator(
                          radius: 45,
                          lineWidth: size.width/30,
                          animation: true,
                          percent: caloriePercentage,
                          center: Text(
                            "${(caloriePercentage*100).round()}%",
                            style:
                            const TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.grey),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Theme.of(context).primaryColor,
                          backgroundColor: greyColor!,
                        ),
                        Container(height: 14,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Row(
                            children: [
                              Text('$dayCalorie', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                              const Text(' calories', style: TextStyle(fontSize: 20),)
                            ],
                          ),
                        )
                      ],);
                  }else{
                    return Container();
                  }
                });
          },
        )
        );
  }
}

// SleepView View
class SleepView extends StatelessWidget {
  const SleepView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmallBlock(
        title: 'Sleep Time',
        icon: Icons.favorite,
        body:
        Consumer<DatabaseRepository>(
          builder: (context, dbr, child){
            return FutureBuilder(
                future: Provider.of<DatabaseRepository>(context).getSleepDataOfDay(DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)))),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    String sleepTime = '';
                    final sleepData = snapshot.data as List<SleepData>;
                    for (var element in sleepData) {sleepTime = element.duration;}
                    RegExp regex = RegExp(r'(\d+) hr, (\d+) min');
                    Match? match = regex.firstMatch(sleepTime);
                    String hours = '';
                    String minutes = '';
                    if (match != null) {
                      // Extract hours and minutes as strings
                      hours = match.group(1)!;
                      minutes = match.group(2)!;
                    } else {
                      print('Invalid time string');
                    }
                    if (hours == '') {
                      hours = '0';
                      minutes = '0';
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(hours, style: const TextStyle(fontSize: 50)),
                            Container(width: 5,),
                            const Text('hr', style: TextStyle(fontSize: 20),),
                            Container(width: 10,),
                            Text(minutes, style: const TextStyle(fontSize: 50)),
                            Container(width: 5,),
                            const Text('min', style: TextStyle(fontSize: 20),)
                          ],),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child:  Text('Last Night', style: TextStyle(fontSize: 15),),
                        )
                      ],);
                  }else{
                    return Container();
                  }
                });
          },
        )
    );
  }
}

