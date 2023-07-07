// ACTIVITY VIEW

import 'dart:ffi';

import 'package:fitfacts/database/HeartData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fitfacts/database/ActivityData.dart';
import '../database/DatabaseRepo.dart';
import '../navigation/navbar.dart';
import '../quizview/QuizBuilder.dart';
import '../quizview/QuizView.dart';
import '../themes/blocks.dart';
import '../themes/theme.dart';
import 'package:fl_chart/fl_chart.dart';


class activityPage extends StatelessWidget {
  const activityPage({Key? key}) : super(key: key);

  static const routename = 'activityPage';

  @override
  Widget build(BuildContext context) {

    var themeMode = context.watch<ThemeModel>().mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.deepPurple[50] : Colors.black;

    print('${activityPage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart'),
      ),
      body: Body(),
      backgroundColor: bkColor,
      drawer: const Navbar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          showModalQuiz(QuizTopic.heart, context);
        },
        child: Icon(Icons.play_arrow_rounded, size: 30,),
        tooltip: 'Take Quiz',
      ),
    );
  } //build
}



class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var themeMode = context.watch<ThemeModel>().mode;


    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 0),
      child: Consumer<DatabaseRepository>(
        builder: (context, dbr, child){
        return FutureBuilder(
        future:Provider.of<DatabaseRepository>(context).getActivityData(),
        builder: (context, snapshot){
        if (snapshot.hasData){
          final activity_data = snapshot.data as List<ActivityData>;
          List<int> activityReference_ = [];
          activity_data.forEach((element) {
            activityReference_.add(element.activityReference);
          });
          //liste con gli argomenti
          return ListView.builder(
                itemCount: activityReference_.length,
                itemBuilder: (context, index){
                  print(index);
                  return activityTile(data: activity_data, index: index);
                  //widget che usa idati dei vettori
                },
          );
        }else{
          return Container();
        }
        });
        },),
    );
  }
}


class activityTile extends StatelessWidget {

  final List<ActivityData> data;
  final int index;


  const activityTile({Key? key, required this.data, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ExpansionTile(
            title: largeBlock(
                title: data[index].name + '          ' + data[index].date,
                icon: getIcon(data[index].name),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : [
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, color: Colors.orange ),
                          Text(' ${duration_convert(data[index].activeDuration)}',
                          style: TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(Icons.flag_outlined, color: Colors.black),
                          Text(' ${(data[index].distance*100).round()/100} ' + ((data[index].distanceUnit=='Kilometer') ? 'Km' :  data[index].distanceUnit), style: TextStyle(fontSize: 17),),
                      ]),

                      Row(
                        children: [
                          const Icon(Icons.local_fire_department_outlined, color: Colors.redAccent),
                          Text(' ${data[index].calories.round()} Kcal', style: TextStyle(fontSize: 17),),
                        ],
                      )
                    ]
                ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.speed, color: Colors.green),
                          Text(' ' + ((data[index].speed*10).round()/10).toString() + ' Km/h', style: TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(Icons.favorite_border_outlined, color: Colors.red),
                          Text(' ' + (data[index].avgHR.round().toString() +  ' bpm'), style: TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                          children: [
                            Icon(Icons.air, color: Colors.blueAccent),
                            Text(' ' + ((data[index].vo2max*10).round()/10).toString() + ' ml/kg/min', style: TextStyle(fontSize: 17),),
                          ]
                      ),
                    ],)
                ],
              ),
            ),
            children : [largeBlock(
              title: 'Heart rate levels',
              icon: Icons.bar_chart_outlined,
              body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : [
                      Text('Zone 1  ' + data[index].hl1_range, style: TextStyle(fontSize: 17, color: Colors.green),),

                      Text('Zone 2  ' + data[index].hl2_range, style: TextStyle(fontSize: 17, color: Colors.orange),),

                      Text('Zone 3  '+ data[index].hl3_range, style: TextStyle(fontSize: 17, color: Colors.red),),
                    ]
                ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(' ' + data[index].hl1_time.toString() + ' min', style: TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                        children: [
                          Text(' ' + (data[index].hl2_time.toString()) + ' min', style: TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                          children: [
                            Text(data[index].hl3_time.toString() + ' min' ,style: TextStyle(fontSize: 17),),
                          ]
                      ),

                    ],)
                ],
              ),
            ),],
        ),
      ),
    );
  }
}




IconData getIcon(String name){
  IconData sportIcon;
  switch (name) {
    case 'Bici':
      sportIcon = Icons.directions_bike_outlined;
      break;
    case 'Corsa':
      sportIcon = Icons.directions_run_outlined;
      break;
    case 'Camminata':
      sportIcon = Icons.directions_walk_rounded;
      break;
    default:
      sportIcon = Icons.fitness_center;
  }
  return sportIcon;
}


String duration_convert(double duration){

  int hours = (((duration/1000)/60)/60).toInt();
  int minutes = ((duration/1000)/60).toInt() - hours*60;
  String duration_str = hours.toString() + 'h ' + minutes.toString() + 'min';
  return duration_str;
}



