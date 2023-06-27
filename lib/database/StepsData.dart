import 'package:floor/floor.dart';

@Entity(tableName: 'StepsData')
class StepsData {

  @primaryKey
  int dayReference;

  String date;
  int steps;

  StepsData(this.dayReference, this.date,this.steps);
}

@Entity(tableName: 'StepsDetail')
class StepsDetail {

  @primaryKey
  int hour;
  double steps;

  StepsDetail(this.hour, this.steps);
}

@dao
abstract class StepsDataDao {

  // SELECTION
  @Query('SELECT * FROM StepsData')
  Future<List<StepsData>> findStepsData();

  @Query('SELECT * FROM StepsData WHERE date = :dayRef')
  Future<List<StepsData>> findStepsDataOfDay(int dayRef);

  @Query('SELECT * FROM StepsDetail')
  Future<List<StepsDetail>> findStepsDetail();

  //INSERT
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addStepsData(StepsData withInfo);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addStepsDetail(StepsDetail withInfo);

  //UPDATE
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateStepsData(StepsData withInfo);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateStepsDetail(StepsDetail withInfo);

  //DELETE
  @delete
  Future<void> deleteStepsData(StepsData withInfo);

  @delete
  Future<void> deleteStepsDetail(StepsDetail withInfo);

  @Query('DELETE FROM StepsData')
  Future<void> wipeData();

  @Query('DELETE FROM StepsDetail')
  Future<void> wipeDetail();

}

void printStepsTable(List<StepsData> fromData){
  print('ID\tDate\t\tSteps');
  for (final data in fromData){
    print('${data.dayReference}\t${data.date}\t\t${data.steps}');
  }
}

void printStepsDetail(List<StepsDetail> fromData){
  print('Hour\tSteps');
  for (final data in fromData){
    print('${data.hour}\t${data.steps}');
  }
}