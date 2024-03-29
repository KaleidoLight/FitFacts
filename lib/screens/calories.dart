// CALORIES VIEW

import 'package:fitfacts/database/CalorieData.dart';
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

class CaloriesPage extends StatefulWidget {
  const CaloriesPage({Key? key}) : super(key: key);

  static const routename = 'CaloriesPage';

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  @override
  Widget build(BuildContext context) {
    var themeMode = context.watch<ThemeModel>().mode;
    var bkColor =
        (themeMode == ThemeMode.light) ? Colors.deepPurple[50] : Colors.black;

    print('${CaloriesPage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories'),
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
        onPressed: () {
          showModalQuiz(QuizTopic.calorie, context);
        },
        tooltip: 'Take Quiz',
        child: const Icon(
          Icons.play_arrow_rounded,
          size: 30,
        ),
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
            Container(
              height: 15,
            ),
            const CaloriesView(),
            CaloriesLine(setDay: setDay,),
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

// Calories Weekly View
class CaloriesView extends StatelessWidget {
  const CaloriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context.watch<ThemeModel>().mode;
    final Color? greyColor =
        (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return LargeBlock(
        title: 'Weekly Calories',
        icon: Icons.event_note_rounded,
        extraHeight: 100,
        body: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 0),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child) {
              return FutureBuilder(
                  future: Future.wait([
                    Provider.of<DatabaseRepository>(context).getCalorieData(),
                    Provider.of<DatabaseRepository>(context).getCalorieGoal()
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<Object> data = snapshot.data!;
                      final calorieDetail = data[0] as List<CalorieData>;
                      final calorieGoal = data[1] as int; 
                      List<BarChartGroupData> dataBars = [];
                      for (var e in calorieDetail) {
                        dataBars
                            .add(BarChartGroupData(x: e.dayReference, barRods: [
                          BarChartRodData(
                              toY: e.calorie.toDouble(),
                              width: 15,
                              color: Theme.of(context).primaryColor)
                        ]));
                      }
                      return BarChart(BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: false),
                          barGroups: dataBars,
                          titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: getTitles))),
                          extraLinesData: ExtraLinesData(
                              extraLinesOnTop: true,
                              horizontalLines: [
                                HorizontalLine(
                                    y: calorieGoal.toDouble(),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha(100),
                                    strokeWidth: 5,
                                    strokeCap: StrokeCap.round,
                                    label: HorizontalLineLabel(show: true))
                              ]),
                          barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: greyColor))));
                    } else {
                      return Container();
                    }
                  });
            },
          ),
        ));
  }
}

// calories line
class CaloriesLine extends StatelessWidget {
  final int setDay;
  const CaloriesLine({Key? key, required this.setDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String setdayDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: setDay)));
    var themeMode = context.watch<ThemeModel>().mode;
    final Color? greyColor =
        (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return LargeBlock(
        title: 'Daily Calories Detail',
        icon: Icons.watch_later_rounded,
        date: setdayDate,
        extraHeight: 150,
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child) {
              return FutureBuilder(
                  future:
                    Provider.of<DatabaseRepository>(context).getCalorieDetailOfDate(setdayDate),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final stepsDetail = snapshot.data as List<CalorieDetail>;
                      List<FlSpot> lineData = [];
                      for (var e in stepsDetail) {
                        lineData.add(FlSpot(e.hour.toDouble(), e.calorie));
                      }
                      if (lineData.isEmpty){
                        return const Center(child: Text('No Daily Detail'));
                        } else{
                      return LineChart(LineChartData(
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false))),
                        lineBarsData: [
                          LineChartBarData(
                              spots: lineData,
                              isCurved: false,
                              color: Theme.of(context).primaryColor,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        Theme.of(context)
                                            .primaryColor
                                            .withAlpha(120),
                                        Theme.of(context)
                                            .primaryColor
                                            .withAlpha(20)
                                      ])))
                        ],
                        gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false),
                        lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: greyColor)),
                      ));}
                    } else {
                      return Container();
                    }
                  });
            },
          ),
        ));
  }
}

Widget getTitles(double value, TitleMeta meta) {
  Widget text = const Text('');
  switch (value.toInt()) {
    case 7:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(const Duration(days: 1))));
      break;
    case 6:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(const Duration(days: 2))));
      break;
    case 5:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(const Duration(days: 3))));
      break;
    case 4:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(const Duration(days: 4))));
      break;
    case 3:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(const Duration(days: 5))));
      break;
    case 2:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(const Duration(days: 6))));
      break;
    case 1:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(const Duration(days: 7))));
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 1,
    child: text,
  );
}

