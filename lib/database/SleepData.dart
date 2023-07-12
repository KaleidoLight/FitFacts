import 'package:floor/floor.dart';

@Entity(tableName: 'SleepData')
class SleepData {
  @primaryKey
  int dayReference;
  String start_day;
  String end_day;
  String duration;
  int wake_count;
  int wake_minutes;
  int light_count;
  int light_minutes;
  int rem_count;
  int rem_minutes;
  int deep_count;
  int deep_minutes;

  SleepData(
      {required this.dayReference,
      required this.start_day,
      required this.end_day,
      required this.duration,
      required this.wake_count,
      required this.wake_minutes,
      required this.light_count,
      required this.light_minutes,
      required this.rem_count,
      required this.rem_minutes,
      required this.deep_count,
      required this.deep_minutes});
}

@dao
abstract class SleepDataDao{

  @Query('SELECT * FROM SleepData')
  Future<List<SleepData>> findSleepData();

  @Query('SELECT * FROM SleepData WHERE end_day = :date')
  Future<List<SleepData>> findSleepDataOfDay(String date);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addSleepData(SleepData withInfo);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateSleepData(SleepData withInfo);

  @delete
  Future<void> deleteSleepData(SleepData withInfo);

  @Query('DELETE FROM SleepData')
  Future<void> wipeData();

}


void printSleepTable(List<SleepData> fromData) {
  print('ID\tStart\t\t\tEnd\t\t\tDuration\t\tWake\tLight\tRem\tDeep');
  fromData.forEach((day) {
    print('${day.dayReference.toString().padRight(4)}'
        '${day.start_day.toString().padRight(24)}'
        '${day.end_day.toString().padRight(24)}'
        '${day.duration.toString().padRight(16)}'
        '${day.wake_count.toString().padRight(6)} * ${day.wake_minutes.toString().padRight(6)} min\t'
        '${day.light_count.toString().padRight(6)} * ${day.light_minutes.toString().padRight(6)} min\t'
        '${day.rem_count.toString().padRight(6)} * ${day.rem_minutes.toString().padRight(6)} min\t'
        '${day.deep_count.toString().padRight(6)} * ${day.deep_minutes.toString().padRight(6)} min');
  });
}

