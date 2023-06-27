import 'package:floor/floor.dart';

@Entity(tableName: 'ActivityData')
class ActivityData {

  @primaryKey
  int activityReference;

  String name;
  String date;
  double avgHR;
  double calories;
  double distance;
  String distanceUnit;
  double duration;
  double activeDuration;
  double speed;
  String pace;
  double vo2max;
  String hl1_range;
  double hl1_time;
  String hl2_range;
  double hl2_time;
  String hl3_range;
  double hl3_time;
  String hl4_range;
  double hl4_time;

  ActivityData({
   required this.activityReference,
    required this.name,
    required this.date,
    required this.avgHR,
    required this.vo2max,
    required this.calories,
    required this.distance,
    required this.distanceUnit,
    required this.duration,
    required this.activeDuration,
    required this.speed,
    required this.pace,
    required this.hl1_range,
    required this.hl1_time,
    required this.hl2_range,
    required this.hl2_time,
    required this.hl3_range,
    required this.hl3_time,
    required this.hl4_range,
    required this.hl4_time,

});

}

@dao
abstract class ActivityDataDao{

  @Query('SELECT * from ActivityData')
  Future<List<ActivityData>> findActivityData();

  @Query('SELECT * from ActivityData WHERE date = :date')
  Future<List<ActivityData>> findActivityDataOfDay(String date);
  
  @Query('SELECT COUNT(DISTINCT date) from ActivityData')
  Future<int?> findActivityDaysOnWeek();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addActivityData(ActivityData withInfo);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateActivityData(ActivityData withInfo);

  @delete
  Future<void> deleteActivityData(ActivityData withInfo);

  @Query('DELETE FROM ActivityData')
  Future<void> wipeData();

}