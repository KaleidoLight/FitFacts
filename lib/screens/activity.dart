// ACTIVITY VIEW

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitfacts/database/ActivityData.dart';
import '../database/DatabaseRepo.dart';
import '../navigation/navbar.dart';
import '../quizview/QuizBuilder.dart';
import '../quizview/QuizView.dart';
import '../themes/blocks.dart';
import '../themes/theme.dart';


class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  static const routename = 'activityPage';

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context.watch<ThemeModel>().mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.deepPurple[50] : Colors.black;

    print('${ActivityPage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: Body(),
      backgroundColor: bkColor,
      drawer: const Navbar(),
      onDrawerChanged: (isOpened){
        if(!isOpened){
          setState((){});
        }
      },
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          showModalQuiz(QuizTopic.activity, context);
        },
        tooltip: 'Take Quiz',
        child: const Icon(Icons.play_arrow_rounded, size: 30,),
      ),
    );
  } }



class Body extends StatelessWidget {

  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 0),
      child: Consumer<DatabaseRepository>(
        builder: (context, dbr, child){
        return FutureBuilder(
        future:Provider.of<DatabaseRepository>(context).getActivityData(),
        builder: (context, snapshot){
        if (snapshot.hasData){
          final activityData = snapshot.data as List<ActivityData>;
          return ListView.builder(
                itemCount: activityData.length,
                itemBuilder: (context, index){
                  return ActivityTile(data: activityData, index: activityData.length - index -1);
                  //widget uses data from vectors
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


class ActivityTile extends StatelessWidget {

  final List<ActivityData> data;
  final int index;


  const ActivityTile({Key? key, required this.data, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ExpansionTile(
            title: LargeBlock(
                title: data[index].name,
                date: data[index].date,
                icon: getIcon(data[index].name),
                showBk: false,
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : [
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, color: Colors.orange ),
                          Text(' ${durationConvert(data[index].activeDuration)}',
                          style: const TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(Icons.flag_outlined, color: Colors.blueGrey[500]),
                          Text(' ${(data[index].distance*100).round()/100} ${(data[index].distanceUnit=='Kilometer') ? 'Km' :  data[index].distanceUnit}', style: const TextStyle(fontSize: 17),),
                      ]),

                      Row(
                        children: [
                          const Icon(Icons.local_fire_department_outlined, color: Colors.redAccent),
                          Text(' ${data[index].calories.round()} Kcal', style: const TextStyle(fontSize: 17),),
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
                          const Icon(Icons.speed, color: Colors.green),
                          Text(' ${(data[index].speed*10).round()/10} Km/h', style: const TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                        children: [
                          const Icon(Icons.favorite_border_outlined, color: Colors.red),
                          Text(' ${data[index].avgHR.round()} bpm', style: const TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                          children: [
                            const Icon(Icons.air, color: Colors.blueAccent),
                            Text(' ${(data[index].vo2max*10).round()/10} ml/kg/min', style: const TextStyle(fontSize: 17),),
                          ]
                      ),
                    ],)
                ],
              ),
            ),
            children : [LargeBlock(
              title: 'Heart rate levels',
              icon: Icons.bar_chart_outlined,
              body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : [
                      Text('Zone 1  ${data[index].hl1_range}', style: const TextStyle(fontSize: 17, color: Colors.green),),

                      Text('Zone 2  ${data[index].hl2_range}', style: const TextStyle(fontSize: 17, color: Colors.orange),),

                      Text('Zone 3  ${data[index].hl3_range}', style: const TextStyle(fontSize: 17, color: Colors.deepOrange),),

                      Text('Zone 4  ${data[index].hl4_range}', style: const TextStyle(fontSize: 17, color: Colors.red),),
                    ]
                ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(' ${data[index].hl1_time} min', style: const TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                        children: [
                          Text(' ${data[index].hl2_time} min', style: const TextStyle(fontSize: 17),),
                        ],
                      ),

                      Row(
                          children: [
                            Text('${data[index].hl3_time} min' ,style: const TextStyle(fontSize: 17),),
                          ]
                      ),
                      Row(
                          children: [
                            Text('${data[index].hl4_time} min' ,style: const TextStyle(fontSize: 17),),
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


String durationConvert(double duration){

  int hours = ((duration/1000)/60)~/60;
  int minutes = (duration/1000)~/60 - hours*60;
  String durationStr = '${hours}h ${minutes}min';
  return durationStr;
}



