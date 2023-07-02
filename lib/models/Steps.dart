
/// Steps Class
///
/// The general data parser for Steps
class Steps {
  final String status; // The http response status
  final String message; // The http response message
  final List<StepsData> data; // The 7-days steps data

  Steps({ // Init
    required this.status,
    required this.message,
    required this.data,
  });

  factory Steps.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return Steps(
      status: json['status'],
      message: json['message'],
      data: List<StepsData>.from(
        json['data'].map((data) => StepsData.fromJson(data)),
      ),
    );
  }

  /// day
  ///
  /// Returns the steps data for the [selectedDay]
  StepsData day(int selectedDay){
    return data[selectedDay];
  }

  /// averageStepsWeek
  ///
  /// Returns the weekly average steps made
  int averageStepsWeek(){
    int total = 0;
    int counter = 0;
    for( final day in data){
      total = total + day.totalSteps();
      counter = counter + 1;
    }
    return (total/counter).round();
  }

  /// totalStepsWeek
  ///
  /// Returns the total steps made in a week
  int totalStepsWeek(){
    int total = 0;
    for( final day in data){
      total = total + day.totalSteps();
    }
    return (total).round();
  }

}

/// Steps Data
///
/// An instance of a daily steps log
class StepsData {
  final String date; // YYYY-MM-DD
  final List<StepsLog> data; // The daily step data

  StepsData({ // Init
    required this.date,
    required this.data,
  });

  factory StepsData.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return StepsData(
      date: json['date'],
      data: List<StepsLog>.from(
        json['data'].map((value) => StepsLog.fromJson(value)),
      ),
    );
  }

  /// totalSteps
  ///
  /// Returns the total steps taken in a day
  int totalSteps(){
    double total = 0;
    for (final log in data){
      total = total + double.parse(log.value);
    }
    return total.round();
  }


  /// detail
  ///
  /// Returns the steps of the day grouped by every hour
  Map<int,double> detail(){

    Map<int,double> cumulativeByHour = {};

    for (final daylog in data){
      int hour = int.parse(daylog.time.split(':')[0]);
      double steps = double.parse(double.parse(daylog.value).toStringAsFixed(2));
      cumulativeByHour[hour] = (cumulativeByHour[hour] ?? 0) + steps;
    }

    cumulativeByHour.forEach((key, value) {
      cumulativeByHour[key] = value.roundToDouble();
    });

    return cumulativeByHour;

  }

}

/// StepsLog
///
/// An instance of a single step log in time of day
class StepsLog {
  final String time; // HH:mm:ss
  final String value; // Steps

  StepsLog({ // Init
    required this.time,
    required this.value,
  });

  factory StepsLog.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return StepsLog(
      time: json['time'],
      value: json['value'],
    );
  }

  @override
  String toString() {
    return 'Time: $time, Steps: $value';
  }
}
