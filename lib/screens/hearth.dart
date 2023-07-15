// HEART VIEW

import 'package:fitfacts/database/HeartData.dart';
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
import 'dart:math';

class HeartPage extends StatefulWidget {
  const HeartPage({Key? key}) : super(key: key);

  static const routename = 'HeartPage';

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {
  @override
  Widget build(BuildContext context) {
    var themeMode = context.watch<ThemeModel>().mode;
    var bkColor =
        (themeMode == ThemeMode.light) ? Colors.deepPurple[50] : Colors.black;

    print('${HeartPage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart'),
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
          showModalQuiz(QuizTopic.heart, context);
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
            const HeartView(),
            HeartLine(setDay: setDay),
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

// heart View
class HeartView extends StatelessWidget {
  const HeartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context.watch<ThemeModel>().mode;
    final Color? greyColor =
        (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return LargeBlock(
        title: 'Weekly Mean Heart Beat',
        icon: Icons.event_note_rounded,
        extraHeight: 100,
        body: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 0),
          child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child) {
              return FutureBuilder(
                  future:
                      Provider.of<DatabaseRepository>(context).getHeartData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      try {
                        final data = snapshot.data as List<HeartData>;
                        //daily mean hr
                        Map<int, int> avgBpm = {};
                        for (var daySubtract = 1;
                            daySubtract < 8;
                            daySubtract++) {
                          double dayBPM = 0.1;
                          int dayCounts = 0;
                          for (var element in data) {
                            if (element.date ==
                                DateFormat('yyyy-MM-dd').format(DateTime.now()
                                    .subtract(Duration(days: daySubtract)))) {
                              dayBPM = dayBPM + element.beats;
                              dayCounts = dayCounts + 1;
                            }
                          }
                          try {
                            avgBpm[daySubtract] = (dayBPM / dayCounts).round();
                          } catch (error) {
                            avgBpm[daySubtract] = 0;
                          }
                        }
                        List<BarChartGroupData> dataBars = [];

                        //min max hr
                        Map<int, int> minHr = {};
                        Map<int, int> maxHr = {};
                        for (var daySubtract = 1;
                            daySubtract < 8;
                            daySubtract++) {
                          List<int> dayBeats = [];
                          for (var element in data) {
                            if (element.date ==
                                DateFormat('yyyy-MM-dd').format(DateTime.now()
                                    .subtract(Duration(days: daySubtract)))) {
                              dayBeats.add(element.beats.toInt());
                            }
                          }
                          minHr[daySubtract] = dayBeats.reduce(min);
                          maxHr[daySubtract] = dayBeats.reduce(max);
                        }

                        avgBpm.forEach((key, value) {
                          dataBars.add(BarChartGroupData(x: key, barRods: [
                            BarChartRodData(
                                fromY: avgBpm[8 - key]!.toDouble() - 1,
                                toY: avgBpm[8 - key]!.toDouble() + 1,
                                width: 15,
                                backDrawRodData: BackgroundBarChartRodData(
                                    fromY: minHr[8 - key]!.toDouble(),
                                    toY: maxHr[8 - key]!.toDouble(),
                                    show: true,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha(100)),
                                color: Theme.of(context).primaryColor)
                          ]));
                        });

                        return BarChart(BarChartData(
                            borderData: FlBorderData(show: false),
                            barGroups: dataBars,
                            titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: getTitles))),
                            gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                drawVerticalLine: false),
                            barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: greyColor))));
                      } catch (e) {
                        return Center(child: Text('No Data Found'),);
                      }
                    } else {
                      return Container();
                    }
                  });
            },
          ),
        ));
  }
}

// heart line
class HeartLine extends StatelessWidget {
  final int setDay;
  const HeartLine({Key? key, required this.setDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context.watch<ThemeModel>().mode;
    final String setdayDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: setDay)));
    final Color? greyColor =
        (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return LargeBlock(
      title: 'Daily Heart Beat Detail',
      date: setdayDate,
      icon: Icons.watch_later_rounded,
      extraHeight: 180,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            return FutureBuilder(
                future: Provider.of<DatabaseRepository>(context).getHeartData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final heartDetail = snapshot.data as List<HeartData>;
                    List<FlSpot> lineData = [];
                    for (var e in heartDetail) {
                      if (e.date == setdayDate) {
                        String temp = e.time.replaceAll(':', '.');
                        //print(temp);
                        lineData.add(FlSpot(double.parse(temp), e.beats));
                      }
                    }
                    if (lineData.isEmpty) {
                      return const Center(child: Text('No Daily Detail'));
                    } else {
                      return LineChart(LineChartData(
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false))),
                        clipData: FlClipData(top: true, bottom: true, left: false, right: false),
                        lineBarsData: [
                          LineChartBarData(
                              spots: lineData,
                              isCurved: false,
                              color: Theme.of(context).primaryColor,
                              barWidth: 3,
                              dotData: FlDotData(
                                show: false,
                              ),
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
                      ));
                    }
                  } else {
                    return Container();
                  }
                });
          },
        ),
      ),
    );
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
