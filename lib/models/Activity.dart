
class Activity {
  final String status;
  final int code;
  final String message;
  final List<ActivityDay> data;

  Activity({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: List<ActivityDay>.from(json['data'].map((day) => ActivityDay.fromJson(day))),
    );
  }

  ActivityDay day(int selecetedDay){
    return data[selecetedDay];
  }

  @override
  String toString() {
    return '\n\n|ACTIVITY|\nStatus: $status -- ($code)\nMessage: $message\nActivity Days: ${data.length}\n';
  }
}

class ActivityDay {
  final String date;
  final List<ActivityLog> data;

  ActivityDay({required this.date, required this.data});

  factory ActivityDay.fromJson(Map<String, dynamic> json) {
    return ActivityDay(
      date: json['date'],
      data: List<ActivityLog>.from(json['data'].map((log) => ActivityLog.fromJson(log))),
    );
  }

  @override
  String toString() {
    return '\n\n|ACTIVITY DAY|\nDATE:$date\nACTIVITIES: ${data.length}';
  }


}

class ActivityLog {
  final String logId;
  final String activityName;
  final String activityTypeId;
  final num averageHeartRate;
  final num calories;
  final num distance;
  final String distanceUnit;
  final num duration;
  final num activeDuration;
  final List<HeartRateZone> heartRateZones;
  final num speed;
  final String pace;
  final ActivityVO2Max vo2Max;

  ActivityLog({
    required this.logId,
    required this.activityName,
    required this.activityTypeId,
    required this.averageHeartRate,
    required this.calories,
    required this.distance,
    required this.distanceUnit,
    required this.duration,
    required this.activeDuration,
    required this.heartRateZones,
    required this.speed,
    required this.pace,
    required this.vo2Max,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      logId: json['logId'] ?? '',
      activityName: json['activityName'] ?? '',
      activityTypeId: json['activityTypeId'] ?? '',
      averageHeartRate: json['averageHeartRate'] ?? 0,
      calories: json['calories'] ?? 0,
      distance: json['distance'] ?? 0.0,
      distanceUnit: json['distanceUnit'] ?? '',
      duration: json['duration'] ?? 0.0,
      activeDuration: json['activeDuration'] ?? 0.0,
      heartRateZones: List<HeartRateZone>.from(json['heartRateZones'].map((zone) => HeartRateZone.fromJson(zone))),
      speed: json['speed'] ?? 0.0,
      pace: json['pace'] ?? '',
      vo2Max: ActivityVO2Max.fromJson(json['vo2Max'] ?? {}),
    );
  }

  @override
  String toString() {
    return '\n\n|$activityName|\n'
        '-- logId: $logId\n'
        '-- activityTypeId: $activityTypeId\n'
        '-- averageHeartRate: $averageHeartRate\n'
        '-- calories: $calories\n'
        '-- distance: $distance ($distanceUnit)\n'
        '-- duration: $duration, active: $activeDuration\n'
        '-- speed: $speed, pace: $pace\n'
        '-- vo2Max: ${vo2Max.toString()}\n'
        '-- heartRateZones:${heartRateZones.toString()}';
  }

}

class HeartRateZone {
  final String name;
  final num min;
  final num max;
  final num minutes;


  HeartRateZone({
    required this.name,
    required this.min,
    required this.max,
    required this.minutes,
  });

  factory HeartRateZone.fromJson(Map<String, dynamic> json) {
    return HeartRateZone(
      name: json['name'] ?? '',
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
      minutes: json['minutes'] ?? 0,
    );
  }

  @override
  String toString() {
    return '\n---- $name, Min: $min, Max: $max, Minutes: $minutes';
  }
}

class ActivityVO2Max {
  final num vo2Max;

  ActivityVO2Max({required this.vo2Max});

  factory ActivityVO2Max.fromJson(Map<String, dynamic> json) {
    return ActivityVO2Max(
      vo2Max: json['vo2Max'] ?? 0.0,
    );
  }

  @override
  String toString() {
    return '$vo2Max';
  }
}
