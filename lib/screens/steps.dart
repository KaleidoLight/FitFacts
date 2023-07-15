// STEPS VIEW

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fitfacts/database/StepsData.dart';
import '../database/DatabaseRepo.dart';
import '../navigation/navbar.dart';
import '../quizview/QuizBuilder.dart';
import '../quizview/QuizView.dart';
import '../themes/blocks.dart';
import '../themes/theme.dart';
import 'package:fl_chart/fl_chart.dart';


class StepsPage extends StatefulWidget {
  const StepsPage({Key? key}) : super(key: key);

  static const routename = 'StepsPage';

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context.watch<ThemeModel>().mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.deepPurple[50] : Colors.black;

    print('${StepsPage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps'),
      ),
      body: const Body(),
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
          showModalQuiz(QuizTopic.step, context);
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
            const StepsView(),
            StepsLine(setDay: setDay,),
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

// Steps View
class StepsView extends StatelessWidget {
  const StepsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return LargeBlock(
        title: 'Weekly Steps',
        icon: Icons.event_note_rounded,
        extraHeight: 100,
        body: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 0),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child){
              return FutureBuilder(
                  future:Future.wait([Provider.of<DatabaseRepository>(context).getStepsData(), Provider.of<DatabaseRepository>(context).getStepGoal()]),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      final List<Object> data = snapshot.data!;
                      final stepsDetail = data[0] as List<StepsData>;
                      final stepsGoal = data[1] as int;
                      List<BarChartGroupData> dataBars = [];
                      for (var e in stepsDetail) {
                        dataBars.add(
                          BarChartGroupData(x: e.dayReference, barRods: [BarChartRodData(toY: e.steps.toDouble(), width: 15, color: Theme.of(context).primaryColor)])
                        );
                      }
                      return BarChart(BarChartData(
                        borderData: FlBorderData(show: false),
                        barGroups: dataBars,
                        titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles))),
                          gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
                          extraLinesData: ExtraLinesData(extraLinesOnTop: true,
                              horizontalLines: [
                                HorizontalLine(
                                    y: stepsGoal.toDouble(),
                                    color: Theme.of(context).primaryColor.withAlpha(100),
                                    strokeWidth: 5,
                                    strokeCap: StrokeCap.round,
                                    label: HorizontalLineLabel(show: true)
                                )]),
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

// Line View
class StepsLine extends StatelessWidget {
  final int setDay;
  const StepsLine({Key? key, required this.setDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final String setdayDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: setDay)));
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return LargeBlock(
        title: 'Daily Steps Detail',
        date: setdayDate,
        icon: Icons.watch_later_rounded,
        extraHeight: 150,
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child){
              return FutureBuilder(
                  future: Future.wait([Provider.of<DatabaseRepository>(context).getStepsDetailOfDay(setdayDate), Provider.of<DatabaseRepository>(context).getStepGoal()]),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      final List<Object> data = snapshot.data!;
                      final stepsDetail = data[0] as List<StepsDetail>;
                      List<StepsDetail> stepSorted = List.from(stepsDetail);
                      stepSorted.sort((a,b) => a.hour.compareTo(b.hour)); // order bug solving
                      List<FlSpot> lineData =[];
                      for (var e in stepSorted) {
                        lineData.add(FlSpot(e.hour.toDouble(), e.steps));
                      }
                      if (lineData.isEmpty){
                        return const Center(child: Text('No Daily Detail'));
                      } else{
                      return LineChart(LineChartData(
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
                        lineBarsData: [LineChartBarData(
                            spots: lineData,
                            isCurved: false,
                            color: Theme.of(context).primaryColor,
                            barWidth: 3,
                            belowBarData: BarAreaData(show: true, gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Theme.of(context).primaryColor.withAlpha(120),Theme.of(context).primaryColor.withAlpha(20)]))
                        )],
                        gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false),
                        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(tooltipBgColor: greyColor)),
                      ));}
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
    case 7:
      text =  Text(DateFormat('E').format(DateTime.now().subtract(const Duration(days: 1))));
      break;
    case 6:
      text =  Text(DateFormat('E').format(DateTime.now().subtract(const Duration(days: 2))));
      break;
    case 5:
      text =  Text(DateFormat('E').format(DateTime.now().subtract(const Duration(days: 3))));
      break;
    case 4:
      text =  Text(DateFormat('E').format(DateTime.now().subtract(const Duration(days: 4))));
      break;
    case 3:
      text =  Text(DateFormat('E').format(DateTime.now().subtract(const Duration(days: 5))));
      break;
    case 2:
      text =  Text(DateFormat('E').format(DateTime.now().subtract(const Duration(days: 6))));
      break;
    case 1:
      text =  Text(DateFormat('E').format(DateTime.now().subtract(const Duration(days: 7))));
      break;

  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 1,
    child: text,
  );
}