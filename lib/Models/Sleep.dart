
import 'package:intl/intl.dart';

/// Sleep
///
/// Returns an instance of Sleep Weekly Data
class Sleep {
  final String status;
  final int code;
  final String message;
  final List<SleepDay> data; // The 7-day list of sleep data

  // Init
  Sleep({required this.status, required this.code, required this.message, required this.data});

  factory Sleep.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return Sleep(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: List<SleepDay>.from(json['data'].map((data) => SleepDay.fromJson(data))),
    );
  }

  /// day
  ///
  /// Returns the daily sleep data
  SleepDay day(int selected){
    return data[selected];
  }


}


/// Sleep Day
///
/// An instance of daily sleep data
class SleepDay {
  final String date; // YYYY-MM-DD
  final List<SleepData> data; // List of Sleep data

  SleepDay({required this.date, required this.data}); // Init

  factory SleepDay.fromJson(Map<String, dynamic> json) { // JSON Constructor
    var jsonData = json['data'];
    List<SleepData> sleepDataList;

    if (jsonData is List) {
      sleepDataList = jsonData.map((data) => SleepData.fromJson(data)).toList();
    } else {
      sleepDataList = [SleepData.fromJson(jsonData)];
    }

    return SleepDay(
      date: json['date'],
      data: sleepDataList,
    );
  }

  /// sleepResume
  ///
  /// Returns an instance of [SleepDayResume] as a formatted sleep data container
  SleepDayResume sleepResume(){

    String start= '${DateFormat('yyyy').format(DateTime.now())}-${data.first.startTime}'; // sleep start
    String end= '${DateFormat('yyyy').format(DateTime.now())}-${data.first.endTime}'; // sleep end

    Duration diff = DateTime.parse(end).difference(DateTime.parse(start));
    String duration = '${diff.inHours} hr, ${diff.inMinutes % 60} min'; // formatted sleep duration

    Map<String,SleepLevelSummary> levels = // levels
    { 'deep' : data.first.levels.rem,
      'wake' : data.first.levels.wake,
      'light': data.first.levels.light,
      'rem'  : data.first.levels.rem
    };

    return SleepDayResume(day: date, startDate: start, endDate: end, duration: duration,levels: levels);

  }
}

/// SleepData
///
/// Container of sleep parameters
class SleepData {

  final String logId;
  final String dateOfSleep;
  final String startTime;
  final String endTime;
  final double duration;
  final SleepLevels levels;

  SleepData({ // Init
    required this.logId,
    required this.dateOfSleep,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.levels,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return SleepData(
      logId: json['logId'] ?? '',
      dateOfSleep: json['dateOfSleep'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      duration: json['duration'] ?? 0.0,
      levels: SleepLevels.fromJson(json['levels'] ?? {}),
    );
  }

  @override
  String toString() {
    return '\nDATE: $dateOfSleep\nSTART: $startTime\nEND: $endTime\nDURATION: $duration${levels.toString()}';
  }
}

/// SleepLevels
///
/// Container class for sleep levels
class SleepLevels {

  final SleepLevelSummary deep;
  final SleepLevelSummary wake;
  final SleepLevelSummary light;
  final SleepLevelSummary rem;

  SleepLevels({ // Init
    required this.deep,
    required this.wake,
    required this.light,
    required this.rem,
  });

  factory SleepLevels.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return SleepLevels(
      deep: SleepLevelSummary.fromJson(json['summary']['deep'] ?? {}),
      wake: SleepLevelSummary.fromJson(json['summary']['wake'] ?? {}),
      light: SleepLevelSummary.fromJson(json['summary']['light'] ?? {}),
      rem: SleepLevelSummary.fromJson(json['summary']['rem'] ?? {}),
    );
  }

  @override
  String toString() {
    return '\n-DEEP-  ${deep.toString()}\n-WAKE-  ${wake.toString()}\n-LIGHT-  ${light.toString()}\n-REM-  ${rem.toString()}';
  }
}

/// SleepLevelSummary
///
/// Detail of sleep levels
class SleepLevelSummary {
  final int count;
  final int minutes;
  final int thirtyDayAvgMinutes;

  SleepLevelSummary({ // Init
    required this.count,
    required this.minutes,
    required this.thirtyDayAvgMinutes,
  });

  factory SleepLevelSummary.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return SleepLevelSummary(
      count: json['count'] ?? 0,
      minutes: json['minutes'] ?? 0,
      thirtyDayAvgMinutes: json['thirtyDayAvgMinutes'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Count: $count, Minutes: $minutes, Thirty Day Average: $thirtyDayAvgMinutes';
  }
}


/// SleepDayResume
///
/// Formatter Class for Sleep Daily Data
class SleepDayResume{

  final String day;
  final String startDate;
  final String endDate;
  final String duration;
  final Map<String, SleepLevelSummary> levels;

  SleepDayResume({ // Init
    required this.day,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.levels
});

  @override
  String toString() {
    return '\nDAY: $day\nSTART: $startDate  --  END: $endDate\nDURATION: $duration\n'
        'LEVELS:\n-- REM: ${levels['rem'].toString()}\n-- WAKE: ${levels['wake'].toString()}\n-- '
        'LIGHT: ${levels['light'].toString()}\n-- DEEP: ${levels['deep'].toString()}';

  }

}