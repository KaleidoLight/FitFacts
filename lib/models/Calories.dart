
/// Calories Class
///
/// The general data parser for Calories
class Calories {
  final String status; // http response status
  final String message; // http response message
  final List<CalorieData> data; // The 7-days list of calories burnt

  Calories({ // Init
    required this.status,
    required this.message,
    required this.data,
  });

  factory Calories.fromJson(Map<String, dynamic> json) { // JSON constructor
    return Calories(
      status: json['status'],
      message: json['message'],
      data: List<CalorieData>.from(
        json['data'].map((data) => CalorieData.fromJson(data)),
      ),
    );
  }

  /// Gets data of selected day
  ///
  /// First item in array is [fromDate] day
  CalorieData day(int selectedDay){
    return data[selectedDay];
  }

  /// averageCaloriesWeek
  ///
  /// Returns burnt calories in a weekly average
  int averageCaloriesWeek(){
    int total = 0;
    int counter = 0;
    for( final day in data){
      total = total + day.totalCalories();
      counter = counter + 1;
    }
    return (total/counter).round();
  }

  @override
  String toString() {
    return '\n|CALORIES|\n- WEEKLY AVG: ${averageCaloriesWeek()}';
  }

}

/// Calorie Data
///
/// An instance of a daily calories log
class CalorieData {
  final String date; // date formatted as YYYY-MM-DD
  final List<CalorieLog> data; // The list of calories logs in the day

  CalorieData({ // Init
    required this.date,
    required this.data,
  });

  factory CalorieData.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return CalorieData(
      date: json['date'],
      data: List<CalorieLog>.from(
        json['data'].map((value) => CalorieLog.fromJson(value)),
      ),
    );
  }

  /// totalCalories
  ///
  /// Returns the total calories burnt in the day
  int totalCalories(){
    double total = 0;
    for (final log in data){ // every element
      total = total + double.parse(log.value);
    }
    return total.round();
  }

  /// detail
  ///
  /// Returns the calories burnt in the day in a hourly format
  Map<int,double> detail(){

    Map<int,double> cumulativeByHour = {}; // {hour : calories burnt}

    for (final daylog in data){
      int hour = int.parse(daylog.time.split(':')[0]); // Get the hour from time format HH:mm:ss
      double calories = double.parse(double.parse(daylog.value).toStringAsFixed(2)); // calories burnt rounded to 2 decimals
      cumulativeByHour[hour] = (cumulativeByHour[hour] ?? 0) + calories; // cumulative sum by hour
    }

    cumulativeByHour.forEach((key, value) {
      cumulativeByHour[key] = value.roundToDouble(); // double rounding
    });

    return cumulativeByHour;

  }

  @override
  String toString() {
    return '\nDATE: $date\n TOTAL CALORIES: ${totalCalories()} (kcal)';
  }
}

/// CalorieLog
///
/// An instance of a single calorie log in time of day
class CalorieLog {
  final String time; // time format HH:mm:ss
  final String value; // calories burnt

  CalorieLog({ // Init
    required this.time,
    required this.value,
  });

  factory CalorieLog.fromJson(Map<String, dynamic> json) { // JSON Constructor
    return CalorieLog(
      time: json['time'],
      value: json['value'],
    );
  }

  @override
  String toString() {
    return 'Time: $time, Calories Burnt: $value';
  }
}
