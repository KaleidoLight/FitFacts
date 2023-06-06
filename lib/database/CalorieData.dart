import 'package:floor/floor.dart';

@Entity(tableName: 'CalorieData')
class CalorieData {

  @primaryKey
  int dayReference;

  String date;
  int calorie;

  CalorieData(this.dayReference, this.date,this.calorie);
}

@Entity(tableName: 'CalorieDetail')
class CalorieDetail {

  @primaryKey
  int hour;
  double calorie;

  CalorieDetail(this.hour, this.calorie);
}

@dao
abstract class CalorieDataDao {

  // SELECTION
  @Query('SELECT * FROM CalorieData')
  Future<List<CalorieData>> findCalorieData(); // get all calorie data

  @Query('SELECT * FROM CalorieData WHERE date = :dayRef') // get calorie data of specific day
  Future<List<CalorieData>> findCalorieDataOfDay(int dayRef);

  @Query('SELECT * FROM CalorieDetail')
  Future<List<CalorieDetail>> findCalorieDetail();

  //INSERT
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addCalorieData(CalorieData withInfo);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addCalorieDetail(CalorieDetail withInfo);

  //UPDATE
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateCalorieData(CalorieData withInfo);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateCalorieDetail(CalorieDetail withInfo);

  //DELETE
  @delete
  Future<void> deleteCalorieData(CalorieData withInfo);

  @delete
  Future<void> deleteCalorieDetail(CalorieDetail withInfo);

  @Query('DELETE FROM CalorieData')
  Future<void> wipeData();

  @Query('DELETE FROM CalorieDetail')
  Future<void> wipeDetail();

}

void printCalorieTable(List<CalorieData> fromData){
  print('ID\tDate\t\tCalories');
  for (final data in fromData){
    print('${data.dayReference}\t${data.date}\t\t${data.calorie}');
  }
}

void printCalorieDetail(List<CalorieDetail> fromData){
  print('Hour\tCalories');
  for (final data in fromData){
    print('${data.hour}\t${data.calorie}');
  }
}