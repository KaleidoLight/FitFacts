// SLEEP VIEW

import 'package:fitfacts/database/SleepData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../database/DatabaseRepo.dart';
import '../navigation/navbar.dart';
import '../quizview/QuizBuilder.dart';
import '../quizview/QuizView.dart';
import '../themes/blocks.dart';
import '../themes/theme.dart';
import 'package:fl_chart/fl_chart.dart';


class SleepPage extends StatefulWidget {
  const SleepPage({Key? key}) : super(key: key);

  static const routename = 'SleepPage';

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context.watch<ThemeModel>().mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.deepPurple[50] : Colors.black;

    print('${SleepPage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep'),
      ),
      body: Body(),
      backgroundColor: bkColor,
      drawer: const Navbar(),
      onDrawerChanged: (isOpened){
        if(!isOpened){
          Provider.of<DatabaseRepository>(context, listen: false).updateView();
        }
      },
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          showModalQuiz(QuizTopic.sleep, context);
        },
        tooltip: 'Take Quiz',
        child: const Icon(Icons.play_arrow_rounded, size: 30,),
      ),
    );
  } }

class Body extends StatefulWidget {

  const Body({super.key});
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int setDay = 1;

  @override
  void initState() {
    super.initState();
    setDay = 1;
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: <Widget>[
        Wrap(
          children: [
            Container(height: 15,),
            SleepZonesMin(setDay: setDay,),
            SleepZonesTimes(setDay: setDay,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (setDay < 7) {
                          setDay = setDay + 1;
                        }
                      });
                    },
                    child: const Icon(Icons.arrow_back)),
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (setDay > 1) {
                          setDay = setDay - 1;
                        }
                      });
                    },
                    child: const Icon(Icons.arrow_forward)),
              ],
            )
          ],
        )
      ],
    );
  }
}

// SleepZones View Minutes
class SleepZonesMin extends StatelessWidget {
  final int setDay;
  const SleepZonesMin({Key? key, required this.setDay}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final String setdayDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: setDay)));
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return LargeBlock(
        title: 'Sleep Zones: Minutes',
        date: setdayDate,
        icon: Icons.pie_chart_rounded,
        extraHeight: 150,
        body: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 7),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child){
              return FutureBuilder(
                  future: Future.wait([Provider.of<DatabaseRepository>(context).getSleepDataOfDay(DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: setDay))))]),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      final List<Object> data = snapshot.data!;
                      try {
                        final sleepData = data[0] as List<SleepData>;
                        final sleepZonesData = sleepData.last;
                        return PieChart(PieChartData(
                            startDegreeOffset: 0,
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 10,
                            centerSpaceRadius: double.infinity,
                            sections: [
                              PieChartSectionData(showTitle: false,
                                  value:sleepZonesData.wake_minutes.toDouble(),
                                  title: 'Wake', radius: 60, color: Theme.of(context).primaryColor.withAlpha(80),
                                  badgeWidget: Chip(label: Text('Wake ${sleepZonesData.wake_minutes} min', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), backgroundColor: greyColor, elevation: 3,),
                                  badgePositionPercentageOffset: 1
                              ),
                              PieChartSectionData(showTitle: false,
                                  value:sleepZonesData.light_minutes.toDouble(),
                                  title: 'Light', radius: 60, color: Theme.of(context).primaryColor.withAlpha(120),
                                  badgeWidget: Chip(label: Text('Light ${sleepZonesData.light_minutes} min', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), backgroundColor: greyColor, elevation: 3,),
                                  badgePositionPercentageOffset: 1
                              ),
                              PieChartSectionData(showTitle: false,
                                  value:sleepZonesData.rem_minutes.toDouble(),
                                  title: 'Rem', radius: 60, color: Theme.of(context).primaryColor.withAlpha(180),
                                  badgeWidget: Chip(label: Text('Rem ${sleepZonesData.rem_minutes} min', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), backgroundColor: greyColor, elevation: 3,),
                                  badgePositionPercentageOffset: 1
                              ),
                              PieChartSectionData(showTitle: false,
                                  value:sleepZonesData.deep_minutes.toDouble(),
                                  title: 'Deep', radius: 60, color: Theme.of(context).primaryColor.withAlpha(220),
                                  badgeWidget: Chip(label: Text('Deep ${sleepZonesData.deep_minutes} min', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), backgroundColor: greyColor, elevation: 3,),
                                  badgePositionPercentageOffset: 1
                              ),
                            ]
                        ),
                        );
                      }
                      catch(error){
                        print(error);
                        return const Center(child: Text('No Sleep Data found for this day'));
                      }
                    }else{
                      return Container();
                    }
                  });
            },
          ),
        )
    );
  }
}

// SleepZones View Minutes
class SleepZonesTimes extends StatelessWidget {
  final int setDay;

  const SleepZonesTimes({Key? key, required this.setDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String setdayDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: setDay)));
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return LargeBlock(
        title: 'Sleep Zones: Counts',
        date: setdayDate,
        icon: Icons.pie_chart_rounded,
        extraHeight: 150,
        body: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 7),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child){
              return FutureBuilder(
                  future: Future.wait([Provider.of<DatabaseRepository>(context).getSleepDataOfDay(DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: setDay))))]),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      final List<Object> data = snapshot.data!;
                      try {
                        final sleepData = data[0] as List<SleepData>;
                        final sleepZonesData = sleepData.last;
                        List<BarChartGroupData> dataBars = [];
                        dataBars.add(BarChartGroupData(x: 0, barRods: [BarChartRodData(color: Theme.of(context).primaryColor.withAlpha(80), toY: sleepZonesData.wake_count.toDouble())]));
                        dataBars.add(BarChartGroupData(x: 1, barRods: [BarChartRodData(color: Theme.of(context).primaryColor.withAlpha(120),toY: sleepZonesData.light_count.toDouble())]));
                        dataBars.add(BarChartGroupData(x: 2, barRods: [BarChartRodData(color: Theme.of(context).primaryColor.withAlpha(180),toY: sleepZonesData.rem_count.toDouble())]));
                        dataBars.add(BarChartGroupData(x: 3, barRods: [BarChartRodData(color: Theme.of(context).primaryColor.withAlpha(220),toY: sleepZonesData.deep_count.toDouble())]));
                        return BarChart(BarChartData(
                            borderData: FlBorderData(show: false),
                            barGroups: dataBars,
                            gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                drawVerticalLine: false),
                            titlesData: FlTitlesData(
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles))),
                            barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(tooltipBgColor: greyColor))
                        ));
                      } catch (error){
                        print(error);
                        return const Center(child: Text('No Sleep Data found for this day'));
                      }
                    }else{
                      return Container();
                    }
                  });
            },
          ),
        )
    );
  }
}

Widget getTitles(double value, TitleMeta meta){
  Widget text = const Text('');
  switch (value.toInt()) {
    case 0:
      text =  const Text('AWAKE');
      break;
    case 1:
      text =  const Text('LIGHT');
      break;
    case 2:
      text = const Text('REM');
      break;
    case 3:
      text =  const Text('DEEP');
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 2,
    child: text,
  );
}