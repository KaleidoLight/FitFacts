
/// Calories Class
///
/// The general data parser for Calories
class HeartRate {
  final String status; // http response status
  final String message; // http response message
  final List<HeartData> data; // The 7-day list of HeartRate data

  HeartRate({ // Init
    required this.status,
    required this.message,
    required this.data,
  });

  factory HeartRate.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return HeartRate(
      status: json['status'],
      message: json['message'],
      data: List<HeartData>.from(
        json['data'].map((data) => HeartData.fromJson(data)),
      ),
    );
  }

  /// Gets data of selected day
  ///
  /// First item in array is [fromDate] day
  HeartData day(int selectedDay){
    return data[selectedDay];
  }

}

/// HeartRate Data
///
/// An instance of a daily heartbeat logs
class HeartData {
  final String date; // YYYY-MM-DD
  final List<HeartLog> data; // The daily list of logged heart-rates

  HeartData({ // Init
    required this.date,
    required this.data,
  });

  factory HeartData.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return HeartData(
      date: json['date'],
      data: List<HeartLog>.from(
        json['data'].map((value) => HeartLog.fromJson(value)),
      ),
    );
  }

  /// dailyMean
  ///
  /// Returns the daily mean heart-rate weighted by confidence
  double dailyMean(){

    List<int> values = [];
    List<int> weights = [];

    for (final entry in data){
      values.add(entry.value);
      weights.add(entry.confidence);
    }
    return _weightedMean(values, weights);
  }

  /// hourlyMean
  ///
  /// Returns the hourly mean heart-rate weighted by confidence
  Map<int,double> hourlyMean(){

    Map<int, List<int>> meanByHour = {};
    Map<int, double> meanResult = {};

    for (final daylog in data) {
      int hour = int.parse(daylog.time.split(':')[0]);
      int heartbeat = daylog.value;
      int confidence = daylog.confidence;

      meanByHour.putIfAbsent(hour, () => [0, 0]);
      meanByHour[hour]![0] = (meanByHour[hour]![0]) + heartbeat * confidence;
      meanByHour[hour]![1] = (meanByHour[hour]![1]) + confidence;
    }

    meanByHour.forEach((key, value) {
      if (value[1] != 0) {
        meanResult[key] = (value[0] / value[1]).roundToDouble();
      } else {
        meanResult[key] = 0.0;
      }
    });

    return meanResult;

  }

  /// fiveMinuteMean
  ///
  /// Returns the weighted mean heartbeat every 5 minutes of day
  Map<String, double> fiveMinuteMean() {
    Map<String, List<int>> meanByFiveMinute = {};
    Map<String, double> meanResult = {};

    for (final daylog in data) {
      String time = daylog.time;
      int heartbeat = daylog.value;
      int confidence = daylog.confidence;

      String fiveMinuteKey = _getFiveMinuteKey(time);

      meanByFiveMinute.putIfAbsent(fiveMinuteKey, () => [0, 0]);
      meanByFiveMinute[fiveMinuteKey]![0] += heartbeat * confidence;
      meanByFiveMinute[fiveMinuteKey]![1] += confidence;
    }

    meanByFiveMinute.forEach((key, value) {
      if (value[1] != 0) {
        meanResult[key] = (value[0] / value[1]).roundToDouble();
      } else {
        meanResult[key] = 0.0;
      }
    });

    return meanResult;
  }

}

/// HeartLog
///
/// An instance of a single heartbeat log
class HeartLog {

  final String time; // HH:mm:ss
  final int value; // bpm
  final int confidence; // factor{1,2,3}

  HeartLog({ // Init
    required this.time,
    required this.value,
    required this.confidence
  });

  factory HeartLog.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return HeartLog(
      time: json['time'],
      value: json['value'],
      confidence: json['confidence']
    );
  }

  @override
  String toString() {
    return 'Time: $time, BPM: $value, Confidence: $confidence';
  }
}

//// UTILS ////

/// weightedMean -PRIVATE-
///
/// Return the mean of [values] weighted by [weights]
double _weightedMean(List<int> values, List<int> weights){
  if (values.length != weights.length) {
    throw ArgumentError("The number of numbers and weights must be the same.");
  }

  double sumProduct = 0.0;
  double sumWeights = 0.0;

  for (int i = 0; i < values.length; i++) {
    sumProduct += values[i] * weights[i];
    sumWeights += weights[i];
  }

  return (sumProduct / sumWeights).roundToDouble();
}

/// getFiveMinuteKey: -PRIVATE-
///
/// Get the formatted five minute key for heart-rate count
String _getFiveMinuteKey(String time) {
  List<String> parts = time.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  int fiveMinuteInterval = (minute / 5).floor();
  int fiveMinute = fiveMinuteInterval * 5;

  String fiveMinuteKey = '$hour:${fiveMinute.toString().padLeft(2, '0')}';

  return fiveMinuteKey;
}