import 'package:floor/floor.dart';


@Entity(tableName: 'HeartData')
class HeartData{

  @primaryKey
  int dayReference;

  String date;
  String time;
  double beats;

  HeartData(this.dayReference, this.date, this.time, this.beats);
}


@dao
abstract class HeartDataDao {

  //Query All Data
  @Query('SELECT * FROM HeartData')
  Future<List<HeartData>> findHeartData();

  //Query Specific Day
  @Query('SELECT * FROM HeartData WHERE date = :date')
  Future<List<HeartData>> findHeartDataOfDay(String date);

  //Insert Heart Data
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addHeartData(HeartData withInfo);

  //Update Heart Data
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateHeartData(HeartData withInfo);

  //Delete Heart Data
  @delete
  Future<void> deleteHeartData(HeartData withInfo);

  @Query('DELETE FROM HeartData')
  Future<void> wipeData();

}

void printHeartTable(List<HeartData> fromData){
  print('ID\tDate\t\tTime\t\tHeartBeats');
  for (final data in fromData){
    print('${data.dayReference}\t${data.date}\t\t${data.time}\t\t${data.beats}');
  }
}
