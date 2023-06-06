// entity/UserInfo.dart

import 'package:floor/floor.dart';

@Entity(tableName: 'UserInfo')
class UserInfo {

  @primaryKey
  int userKey = 1;
  String username;
  String birthDay;
  String sex;
  int height;
  int weight;
  int calorieGoal;
  int stepGoal;

  UserInfo(this.username, this.birthDay, this.sex, this.height, this.weight, this.calorieGoal, this.stepGoal);
  
}

@dao
abstract class UserInfoDao {

  // SELECTION
  @Query('SELECT * FROM UserInfo')
  Future<List<UserInfo>> findAllUsers(); // get all users

  //INSERT
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> registerUser(UserInfo withInfo);

  //UPDATE
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUser(UserInfo withInfo);

  //DELETE
  @delete
  Future<void> deleteUser(UserInfo withInfo);

  @Query('DELETE FROM UserInfo')
  Future<void> wipeData();

}
