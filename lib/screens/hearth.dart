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

class HeartPage extends StatelessWidget {
  const HeartPage({Key? key}) : super(key: key);

  static const routename = 'HeartPage';

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
      body: Body(),
      backgroundColor: bkColor,
      drawer: const Navbar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showModalQuiz(QuizTopic.heart, context);
        },
        child: Icon(
          Icons.play_arrow_rounded,
          size: 30,
        ),
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
  int setDay = 1;

  @override
  void initState() {
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
            HeartView(),
            heartLine(setDay: setDay),
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
                    child: Icon(Icons.arrow_back)),
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (setDay > 1) {
                          setDay = setDay - 1;
                        }
                      });
                    },
                    child: Icon(Icons.arrow_forward)),
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
    return largeBlock(
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
                      final data = snapshot.data as List<HeartData>;

                      //daily mean hr
                      Map<int, int> avg_bpm = {};
                      for (var day_subtract = 1;
                          day_subtract < 8;
                          day_subtract++) {
                        double dayBPM = 0.1;
                        int dayCounts = 0;
                        data.forEach((element) {
                          if (element.date ==
                              DateFormat('yyyy-MM-dd').format(DateTime.now()
                                  .subtract(Duration(days: day_subtract)))) {
                            dayBPM = dayBPM + element.beats;
                            dayCounts = dayCounts + 1;
                          }
                        });
                        try {
                          avg_bpm[day_subtract] = (dayBPM / dayCounts).round();
                        } catch (error) {
                          avg_bpm[day_subtract] = 0;
                        }
                      }
                      List<BarChartGroupData> dataBars = [];

                      //min max hr
                      Map<int, int> min_hr = {};
                      Map<int, int> max_hr = {};
                      for (var day_subtract = 1;
                          day_subtract < 8;
                          day_subtract++) {
                        List<int> day_beats = [];
                        data.forEach((element) {
                          if (element.date ==
                              DateFormat('yyyy-MM-dd').format(DateTime.now()
                                  .subtract(Duration(days: day_subtract)))) {
                            day_beats.add(element.beats.toInt());
                          }
                        });
                        min_hr[day_subtract] = day_beats.reduce(min);
                        max_hr[day_subtract] = day_beats.reduce(max);
                      }

                      avg_bpm.forEach((key, value) {
                        dataBars.add(BarChartGroupData(x: key, barRods: [
                          BarChartRodData(
                              fromY: avg_bpm[8 - key]!.toDouble() - 1,
                              toY: avg_bpm[8 - key]!.toDouble() + 1,
                              width: 15,
                              backDrawRodData: BackgroundBarChartRodData(
                                  fromY: min_hr[8 - key]!.toDouble(),
                                  toY: max_hr[8 - key]!.toDouble(),
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
class heartLine extends StatelessWidget {
  final int setDay;
  const heartLine({Key? key, required this.setDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context.watch<ThemeModel>().mode;
    final String setDay_date = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: setDay)));
    final Color? greyColor =
        (themeMode == ThemeMode.light) ? Colors.grey[200] : Colors.grey[800];
    return largeBlock(
      title: 'Daily Heart Beat Detail',
      date: setDay_date,
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
                    heartDetail.forEach((e) {
                      if (e.date == setDay_date) {
                        String temp = e.time.replaceAll(':', '.');
                        //print(temp);
                        lineData.add(FlSpot(double.parse(temp), e.beats));
                      }
                    });
                    if (lineData.isEmpty) {
                      return const Center(child: Text('No Daily Detail'));
                    } else {
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
  Widget text = Text('');
  switch (value.toInt()) {
    case 7:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(Duration(days: 1))));
      break;
    case 6:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(Duration(days: 2))));
      break;
    case 5:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(Duration(days: 3))));
      break;
    case 4:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(Duration(days: 4))));
      break;
    case 3:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(Duration(days: 5))));
      break;
    case 2:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(Duration(days: 6))));
      break;
    case 1:
      text = Text(
          DateFormat('E').format(DateTime.now().subtract(Duration(days: 7))));
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 1,
    child: text,
  );
}
