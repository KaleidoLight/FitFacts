// SLEEP VIEW

import 'package:fitfacts/database/CalorieData.dart';
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


class SleepPage extends StatelessWidget {
  const SleepPage({Key? key}) : super(key: key);

  static const routename = 'SleepPage';

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
            Container(height: 15,),
            sleepZonesMin(),
            sleepZonesTimes(),
          ],
        )
      ],
    );
  }
}

// SleepZones View Minutes
class sleepZonesMin extends StatelessWidget {
  const sleepZonesMin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return largeBlock(
        title: 'Sleep Zones: Minutes',
        icon: Icons.pie_chart_rounded,
        extraHeight: 150,
        body: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 7),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child){
              return FutureBuilder(
                  future: Future.wait([Provider.of<DatabaseRepository>(context).getSleepDataOfDay(DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1))))]),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      final List<Object> data = snapshot.data!;
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
                              badgeWidget: Chip(label: Text('Wake ${sleepZonesData.wake_minutes} min', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), backgroundColor: greyColor, elevation: 3,),
                              badgePositionPercentageOffset: 1
                          ),
                          PieChartSectionData(showTitle: false,
                              value:sleepZonesData.light_minutes.toDouble(),
                              title: 'Light', radius: 60, color: Theme.of(context).primaryColor.withAlpha(120),
                              badgeWidget: Chip(label: Text('Light ${sleepZonesData.light_minutes} min', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), backgroundColor: greyColor, elevation: 3,),
                              badgePositionPercentageOffset: 1
                          ),
                          PieChartSectionData(showTitle: false,
                              value:sleepZonesData.rem_minutes.toDouble(),
                              title: 'Rem', radius: 60, color: Theme.of(context).primaryColor.withAlpha(180),
                              badgeWidget: Chip(label: Text('Rem ${sleepZonesData.rem_minutes} min', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), backgroundColor: greyColor, elevation: 3,),
                              badgePositionPercentageOffset: 1
                          ),
                          PieChartSectionData(showTitle: false,
                              value:sleepZonesData.deep_minutes.toDouble(),
                              title: 'Deep', radius: 60, color: Theme.of(context).primaryColor.withAlpha(220),
                              badgeWidget: Chip(label: Text('Deep ${sleepZonesData.deep_minutes} min', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), backgroundColor: greyColor, elevation: 3,),
                              badgePositionPercentageOffset: 1
                          ),
                        ]
                      ),
                      );
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
class sleepZonesTimes extends StatelessWidget {
  const sleepZonesTimes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return largeBlock(
        title: 'Sleep Zones: Cycle',
        icon: Icons.pie_chart_rounded,
        extraHeight: 150,
        body: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 7),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child){
              return FutureBuilder(
                  future: Future.wait([Provider.of<DatabaseRepository>(context).getSleepDataOfDay(DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1))))]),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      final List<Object> data = snapshot.data!;
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
                          titlesData: FlTitlesData(
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles))),
                          barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(tooltipBgColor: greyColor))
                      ));
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
  Widget text = Text('');
  switch (value.toInt()) {
    case 0:
      text =  Text('AWAKE');
      break;
    case 1:
      text =  Text('LIGHT');
      break;
    case 2:
      text = Text('REM');
      break;
    case 3:
      text =  Text('DEEP');
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 1,
    child: text,
  );
}