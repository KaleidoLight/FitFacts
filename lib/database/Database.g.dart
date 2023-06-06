// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserInfoDao? _userInfoDaoInstance;

  CalorieDataDao? _calorieDataDaoInstance;

  StepsDataDao? _stepsDataDaoInstance;

  HeartDataDao? _heartDataDaoInstance;

  SleepDataDao? _sleepDataDaoInstance;

  ActivityDataDao? _activityDataDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserInfo` (`userKey` INTEGER NOT NULL, `username` TEXT NOT NULL, `birthDay` TEXT NOT NULL, `sex` TEXT NOT NULL, `height` INTEGER NOT NULL, `weight` INTEGER NOT NULL, `calorieGoal` INTEGER NOT NULL, `stepGoal` INTEGER NOT NULL, PRIMARY KEY (`userKey`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CalorieData` (`dayReference` INTEGER NOT NULL, `date` TEXT NOT NULL, `calorie` INTEGER NOT NULL, PRIMARY KEY (`dayReference`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CalorieDetail` (`hour` INTEGER NOT NULL, `calorie` REAL NOT NULL, PRIMARY KEY (`hour`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `StepsData` (`dayReference` INTEGER NOT NULL, `date` TEXT NOT NULL, `steps` INTEGER NOT NULL, PRIMARY KEY (`dayReference`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `StepsDetail` (`hour` INTEGER NOT NULL, `steps` REAL NOT NULL, PRIMARY KEY (`hour`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `HeartData` (`dayReference` INTEGER NOT NULL, `date` TEXT NOT NULL, `time` TEXT NOT NULL, `beats` REAL NOT NULL, PRIMARY KEY (`dayReference`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SleepData` (`dayReference` INTEGER NOT NULL, `start_day` TEXT NOT NULL, `end_day` TEXT NOT NULL, `duration` TEXT NOT NULL, `wake_count` INTEGER NOT NULL, `wake_minutes` INTEGER NOT NULL, `light_count` INTEGER NOT NULL, `light_minutes` INTEGER NOT NULL, `rem_count` INTEGER NOT NULL, `rem_minutes` INTEGER NOT NULL, `deep_count` INTEGER NOT NULL, `deep_minutes` INTEGER NOT NULL, PRIMARY KEY (`dayReference`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ActivityData` (`activityReference` INTEGER NOT NULL, `name` TEXT NOT NULL, `date` TEXT NOT NULL, `avgHR` REAL NOT NULL, `calories` REAL NOT NULL, `distance` REAL NOT NULL, `distanceUnit` TEXT NOT NULL, `duration` REAL NOT NULL, `activeDuration` REAL NOT NULL, `speed` REAL NOT NULL, `pace` TEXT NOT NULL, `vo2max` REAL NOT NULL, `hl1_range` TEXT NOT NULL, `hl1_time` REAL NOT NULL, `hl2_range` TEXT NOT NULL, `hl2_time` REAL NOT NULL, `hl3_range` TEXT NOT NULL, `hl3_time` REAL NOT NULL, `hl4_range` TEXT NOT NULL, `hl4_time` REAL NOT NULL, PRIMARY KEY (`activityReference`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserInfoDao get userInfoDao {
    return _userInfoDaoInstance ??= _$UserInfoDao(database, changeListener);
  }

  @override
  CalorieDataDao get calorieDataDao {
    return _calorieDataDaoInstance ??=
        _$CalorieDataDao(database, changeListener);
  }

  @override
  StepsDataDao get stepsDataDao {
    return _stepsDataDaoInstance ??= _$StepsDataDao(database, changeListener);
  }

  @override
  HeartDataDao get heartDataDao {
    return _heartDataDaoInstance ??= _$HeartDataDao(database, changeListener);
  }

  @override
  SleepDataDao get sleepDataDao {
    return _sleepDataDaoInstance ??= _$SleepDataDao(database, changeListener);
  }

  @override
  ActivityDataDao get activityDataDao {
    return _activityDataDaoInstance ??=
        _$ActivityDataDao(database, changeListener);
  }
}

class _$UserInfoDao extends UserInfoDao {
  _$UserInfoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInfoInsertionAdapter = InsertionAdapter(
            database,
            'UserInfo',
            (UserInfo item) => <String, Object?>{
                  'userKey': item.userKey,
                  'username': item.username,
                  'birthDay': item.birthDay,
                  'sex': item.sex,
                  'height': item.height,
                  'weight': item.weight,
                  'calorieGoal': item.calorieGoal,
                  'stepGoal': item.stepGoal
                }),
        _userInfoUpdateAdapter = UpdateAdapter(
            database,
            'UserInfo',
            ['userKey'],
            (UserInfo item) => <String, Object?>{
                  'userKey': item.userKey,
                  'username': item.username,
                  'birthDay': item.birthDay,
                  'sex': item.sex,
                  'height': item.height,
                  'weight': item.weight,
                  'calorieGoal': item.calorieGoal,
                  'stepGoal': item.stepGoal
                }),
        _userInfoDeletionAdapter = DeletionAdapter(
            database,
            'UserInfo',
            ['userKey'],
            (UserInfo item) => <String, Object?>{
                  'userKey': item.userKey,
                  'username': item.username,
                  'birthDay': item.birthDay,
                  'sex': item.sex,
                  'height': item.height,
                  'weight': item.weight,
                  'calorieGoal': item.calorieGoal,
                  'stepGoal': item.stepGoal
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserInfo> _userInfoInsertionAdapter;

  final UpdateAdapter<UserInfo> _userInfoUpdateAdapter;

  final DeletionAdapter<UserInfo> _userInfoDeletionAdapter;

  @override
  Future<List<UserInfo>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM UserInfo',
        mapper: (Map<String, Object?> row) => UserInfo(
            row['username'] as String,
            row['birthDay'] as String,
            row['sex'] as String,
            row['height'] as int,
            row['weight'] as int,
            row['calorieGoal'] as int,
            row['stepGoal'] as int));
  }

  @override
  Future<void> wipeData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserInfo');
  }

  @override
  Future<void> registerUser(UserInfo withInfo) async {
    await _userInfoInsertionAdapter.insert(withInfo, OnConflictStrategy.ignore);
  }

  @override
  Future<void> updateUser(UserInfo withInfo) async {
    await _userInfoUpdateAdapter.update(withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(UserInfo withInfo) async {
    await _userInfoDeletionAdapter.delete(withInfo);
  }
}

class _$CalorieDataDao extends CalorieDataDao {
  _$CalorieDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _calorieDataInsertionAdapter = InsertionAdapter(
            database,
            'CalorieData',
            (CalorieData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'calorie': item.calorie
                }),
        _calorieDetailInsertionAdapter = InsertionAdapter(
            database,
            'CalorieDetail',
            (CalorieDetail item) =>
                <String, Object?>{'hour': item.hour, 'calorie': item.calorie}),
        _calorieDataUpdateAdapter = UpdateAdapter(
            database,
            'CalorieData',
            ['dayReference'],
            (CalorieData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'calorie': item.calorie
                }),
        _calorieDetailUpdateAdapter = UpdateAdapter(
            database,
            'CalorieDetail',
            ['hour'],
            (CalorieDetail item) =>
                <String, Object?>{'hour': item.hour, 'calorie': item.calorie}),
        _calorieDataDeletionAdapter = DeletionAdapter(
            database,
            'CalorieData',
            ['dayReference'],
            (CalorieData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'calorie': item.calorie
                }),
        _calorieDetailDeletionAdapter = DeletionAdapter(
            database,
            'CalorieDetail',
            ['hour'],
            (CalorieDetail item) =>
                <String, Object?>{'hour': item.hour, 'calorie': item.calorie});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CalorieData> _calorieDataInsertionAdapter;

  final InsertionAdapter<CalorieDetail> _calorieDetailInsertionAdapter;

  final UpdateAdapter<CalorieData> _calorieDataUpdateAdapter;

  final UpdateAdapter<CalorieDetail> _calorieDetailUpdateAdapter;

  final DeletionAdapter<CalorieData> _calorieDataDeletionAdapter;

  final DeletionAdapter<CalorieDetail> _calorieDetailDeletionAdapter;

  @override
  Future<List<CalorieData>> findCalorieData() async {
    return _queryAdapter.queryList('SELECT * FROM CalorieData',
        mapper: (Map<String, Object?> row) => CalorieData(
            row['dayReference'] as int,
            row['date'] as String,
            row['calorie'] as int));
  }

  @override
  Future<List<CalorieData>> findCalorieDataOfDay(int dayRef) async {
    return _queryAdapter.queryList('SELECT * FROM CalorieData WHERE date = ?1',
        mapper: (Map<String, Object?> row) => CalorieData(
            row['dayReference'] as int,
            row['date'] as String,
            row['calorie'] as int),
        arguments: [dayRef]);
  }

  @override
  Future<List<CalorieDetail>> findCalorieDetail() async {
    return _queryAdapter.queryList('SELECT * FROM CalorieDetail',
        mapper: (Map<String, Object?> row) =>
            CalorieDetail(row['hour'] as int, row['calorie'] as double));
  }

  @override
  Future<void> wipeData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CalorieData');
  }

  @override
  Future<void> wipeDetail() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CalorieDetail');
  }

  @override
  Future<void> addCalorieData(CalorieData withInfo) async {
    await _calorieDataInsertionAdapter.insert(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> addCalorieDetail(CalorieDetail withInfo) async {
    await _calorieDetailInsertionAdapter.insert(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateCalorieData(CalorieData withInfo) async {
    await _calorieDataUpdateAdapter.update(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateCalorieDetail(CalorieDetail withInfo) async {
    await _calorieDetailUpdateAdapter.update(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteCalorieData(CalorieData withInfo) async {
    await _calorieDataDeletionAdapter.delete(withInfo);
  }

  @override
  Future<void> deleteCalorieDetail(CalorieDetail withInfo) async {
    await _calorieDetailDeletionAdapter.delete(withInfo);
  }
}

class _$StepsDataDao extends StepsDataDao {
  _$StepsDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _stepsDataInsertionAdapter = InsertionAdapter(
            database,
            'StepsData',
            (StepsData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'steps': item.steps
                }),
        _stepsDetailInsertionAdapter = InsertionAdapter(
            database,
            'StepsDetail',
            (StepsDetail item) =>
                <String, Object?>{'hour': item.hour, 'steps': item.steps}),
        _stepsDataUpdateAdapter = UpdateAdapter(
            database,
            'StepsData',
            ['dayReference'],
            (StepsData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'steps': item.steps
                }),
        _stepsDetailUpdateAdapter = UpdateAdapter(
            database,
            'StepsDetail',
            ['hour'],
            (StepsDetail item) =>
                <String, Object?>{'hour': item.hour, 'steps': item.steps}),
        _stepsDataDeletionAdapter = DeletionAdapter(
            database,
            'StepsData',
            ['dayReference'],
            (StepsData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'steps': item.steps
                }),
        _stepsDetailDeletionAdapter = DeletionAdapter(
            database,
            'StepsDetail',
            ['hour'],
            (StepsDetail item) =>
                <String, Object?>{'hour': item.hour, 'steps': item.steps});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StepsData> _stepsDataInsertionAdapter;

  final InsertionAdapter<StepsDetail> _stepsDetailInsertionAdapter;

  final UpdateAdapter<StepsData> _stepsDataUpdateAdapter;

  final UpdateAdapter<StepsDetail> _stepsDetailUpdateAdapter;

  final DeletionAdapter<StepsData> _stepsDataDeletionAdapter;

  final DeletionAdapter<StepsDetail> _stepsDetailDeletionAdapter;

  @override
  Future<List<StepsData>> findStepsData() async {
    return _queryAdapter.queryList('SELECT * FROM StepsData',
        mapper: (Map<String, Object?> row) => StepsData(
            row['dayReference'] as int,
            row['date'] as String,
            row['steps'] as int));
  }

  @override
  Future<List<StepsData>> findStepsDataOfDay(int dayRef) async {
    return _queryAdapter.queryList('SELECT * FROM StepsData WHERE date = ?1',
        mapper: (Map<String, Object?> row) => StepsData(
            row['dayReference'] as int,
            row['date'] as String,
            row['steps'] as int),
        arguments: [dayRef]);
  }

  @override
  Future<List<StepsDetail>> findStepsDetail() async {
    return _queryAdapter.queryList('SELECT * FROM StepsDetail',
        mapper: (Map<String, Object?> row) =>
            StepsDetail(row['hour'] as int, row['steps'] as double));
  }

  @override
  Future<void> wipeData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM StepsData');
  }

  @override
  Future<void> wipeDetail() async {
    await _queryAdapter.queryNoReturn('DELETE FROM StepsDetail');
  }

  @override
  Future<void> addStepsData(StepsData withInfo) async {
    await _stepsDataInsertionAdapter.insert(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> addStepsDetail(StepsDetail withInfo) async {
    await _stepsDetailInsertionAdapter.insert(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateStepsData(StepsData withInfo) async {
    await _stepsDataUpdateAdapter.update(withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateStepsDetail(StepsDetail withInfo) async {
    await _stepsDetailUpdateAdapter.update(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteStepsData(StepsData withInfo) async {
    await _stepsDataDeletionAdapter.delete(withInfo);
  }

  @override
  Future<void> deleteStepsDetail(StepsDetail withInfo) async {
    await _stepsDetailDeletionAdapter.delete(withInfo);
  }
}

class _$HeartDataDao extends HeartDataDao {
  _$HeartDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _heartDataInsertionAdapter = InsertionAdapter(
            database,
            'HeartData',
            (HeartData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'time': item.time,
                  'beats': item.beats
                }),
        _heartDataUpdateAdapter = UpdateAdapter(
            database,
            'HeartData',
            ['dayReference'],
            (HeartData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'time': item.time,
                  'beats': item.beats
                }),
        _heartDataDeletionAdapter = DeletionAdapter(
            database,
            'HeartData',
            ['dayReference'],
            (HeartData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'date': item.date,
                  'time': item.time,
                  'beats': item.beats
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HeartData> _heartDataInsertionAdapter;

  final UpdateAdapter<HeartData> _heartDataUpdateAdapter;

  final DeletionAdapter<HeartData> _heartDataDeletionAdapter;

  @override
  Future<List<HeartData>> findHeartData() async {
    return _queryAdapter.queryList('SELECT * FROM HeartData',
        mapper: (Map<String, Object?> row) => HeartData(
            row['dayReference'] as int,
            row['date'] as String,
            row['time'] as String,
            row['beats'] as double));
  }

  @override
  Future<List<HeartData>> findHeartDataOfDay(String date) async {
    return _queryAdapter.queryList('SELECT * FROM HeartData WHERE date = ?1',
        mapper: (Map<String, Object?> row) => HeartData(
            row['dayReference'] as int,
            row['date'] as String,
            row['time'] as String,
            row['beats'] as double),
        arguments: [date]);
  }

  @override
  Future<void> wipeData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM HeartData');
  }

  @override
  Future<void> addHeartData(HeartData withInfo) async {
    await _heartDataInsertionAdapter.insert(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateHeartData(HeartData withInfo) async {
    await _heartDataUpdateAdapter.update(withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteHeartData(HeartData withInfo) async {
    await _heartDataDeletionAdapter.delete(withInfo);
  }
}

class _$SleepDataDao extends SleepDataDao {
  _$SleepDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sleepDataInsertionAdapter = InsertionAdapter(
            database,
            'SleepData',
            (SleepData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'start_day': item.start_day,
                  'end_day': item.end_day,
                  'duration': item.duration,
                  'wake_count': item.wake_count,
                  'wake_minutes': item.wake_minutes,
                  'light_count': item.light_count,
                  'light_minutes': item.light_minutes,
                  'rem_count': item.rem_count,
                  'rem_minutes': item.rem_minutes,
                  'deep_count': item.deep_count,
                  'deep_minutes': item.deep_minutes
                }),
        _sleepDataUpdateAdapter = UpdateAdapter(
            database,
            'SleepData',
            ['dayReference'],
            (SleepData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'start_day': item.start_day,
                  'end_day': item.end_day,
                  'duration': item.duration,
                  'wake_count': item.wake_count,
                  'wake_minutes': item.wake_minutes,
                  'light_count': item.light_count,
                  'light_minutes': item.light_minutes,
                  'rem_count': item.rem_count,
                  'rem_minutes': item.rem_minutes,
                  'deep_count': item.deep_count,
                  'deep_minutes': item.deep_minutes
                }),
        _sleepDataDeletionAdapter = DeletionAdapter(
            database,
            'SleepData',
            ['dayReference'],
            (SleepData item) => <String, Object?>{
                  'dayReference': item.dayReference,
                  'start_day': item.start_day,
                  'end_day': item.end_day,
                  'duration': item.duration,
                  'wake_count': item.wake_count,
                  'wake_minutes': item.wake_minutes,
                  'light_count': item.light_count,
                  'light_minutes': item.light_minutes,
                  'rem_count': item.rem_count,
                  'rem_minutes': item.rem_minutes,
                  'deep_count': item.deep_count,
                  'deep_minutes': item.deep_minutes
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SleepData> _sleepDataInsertionAdapter;

  final UpdateAdapter<SleepData> _sleepDataUpdateAdapter;

  final DeletionAdapter<SleepData> _sleepDataDeletionAdapter;

  @override
  Future<List<SleepData>> findSleepData() async {
    return _queryAdapter.queryList('SELECT * FROM SleepData',
        mapper: (Map<String, Object?> row) => SleepData(
            dayReference: row['dayReference'] as int,
            start_day: row['start_day'] as String,
            end_day: row['end_day'] as String,
            duration: row['duration'] as String,
            wake_count: row['wake_count'] as int,
            wake_minutes: row['wake_minutes'] as int,
            light_count: row['light_count'] as int,
            light_minutes: row['light_minutes'] as int,
            rem_count: row['rem_count'] as int,
            rem_minutes: row['rem_minutes'] as int,
            deep_count: row['deep_count'] as int,
            deep_minutes: row['deep_minutes'] as int));
  }

  @override
  Future<List<SleepData>> findSleepDataOfDay(String date) async {
    return _queryAdapter.queryList('SELECT * FROM SleepData WHERE end_day = ?1',
        mapper: (Map<String, Object?> row) => SleepData(
            dayReference: row['dayReference'] as int,
            start_day: row['start_day'] as String,
            end_day: row['end_day'] as String,
            duration: row['duration'] as String,
            wake_count: row['wake_count'] as int,
            wake_minutes: row['wake_minutes'] as int,
            light_count: row['light_count'] as int,
            light_minutes: row['light_minutes'] as int,
            rem_count: row['rem_count'] as int,
            rem_minutes: row['rem_minutes'] as int,
            deep_count: row['deep_count'] as int,
            deep_minutes: row['deep_minutes'] as int),
        arguments: [date]);
  }

  @override
  Future<void> wipeData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM SleepData');
  }

  @override
  Future<void> addSleepData(SleepData withInfo) async {
    await _sleepDataInsertionAdapter.insert(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateSleepData(SleepData withInfo) async {
    await _sleepDataUpdateAdapter.update(withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteSleepData(SleepData withInfo) async {
    await _sleepDataDeletionAdapter.delete(withInfo);
  }
}

class _$ActivityDataDao extends ActivityDataDao {
  _$ActivityDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _activityDataInsertionAdapter = InsertionAdapter(
            database,
            'ActivityData',
            (ActivityData item) => <String, Object?>{
                  'activityReference': item.activityReference,
                  'name': item.name,
                  'date': item.date,
                  'avgHR': item.avgHR,
                  'calories': item.calories,
                  'distance': item.distance,
                  'distanceUnit': item.distanceUnit,
                  'duration': item.duration,
                  'activeDuration': item.activeDuration,
                  'speed': item.speed,
                  'pace': item.pace,
                  'vo2max': item.vo2max,
                  'hl1_range': item.hl1_range,
                  'hl1_time': item.hl1_time,
                  'hl2_range': item.hl2_range,
                  'hl2_time': item.hl2_time,
                  'hl3_range': item.hl3_range,
                  'hl3_time': item.hl3_time,
                  'hl4_range': item.hl4_range,
                  'hl4_time': item.hl4_time
                }),
        _activityDataUpdateAdapter = UpdateAdapter(
            database,
            'ActivityData',
            ['activityReference'],
            (ActivityData item) => <String, Object?>{
                  'activityReference': item.activityReference,
                  'name': item.name,
                  'date': item.date,
                  'avgHR': item.avgHR,
                  'calories': item.calories,
                  'distance': item.distance,
                  'distanceUnit': item.distanceUnit,
                  'duration': item.duration,
                  'activeDuration': item.activeDuration,
                  'speed': item.speed,
                  'pace': item.pace,
                  'vo2max': item.vo2max,
                  'hl1_range': item.hl1_range,
                  'hl1_time': item.hl1_time,
                  'hl2_range': item.hl2_range,
                  'hl2_time': item.hl2_time,
                  'hl3_range': item.hl3_range,
                  'hl3_time': item.hl3_time,
                  'hl4_range': item.hl4_range,
                  'hl4_time': item.hl4_time
                }),
        _activityDataDeletionAdapter = DeletionAdapter(
            database,
            'ActivityData',
            ['activityReference'],
            (ActivityData item) => <String, Object?>{
                  'activityReference': item.activityReference,
                  'name': item.name,
                  'date': item.date,
                  'avgHR': item.avgHR,
                  'calories': item.calories,
                  'distance': item.distance,
                  'distanceUnit': item.distanceUnit,
                  'duration': item.duration,
                  'activeDuration': item.activeDuration,
                  'speed': item.speed,
                  'pace': item.pace,
                  'vo2max': item.vo2max,
                  'hl1_range': item.hl1_range,
                  'hl1_time': item.hl1_time,
                  'hl2_range': item.hl2_range,
                  'hl2_time': item.hl2_time,
                  'hl3_range': item.hl3_range,
                  'hl3_time': item.hl3_time,
                  'hl4_range': item.hl4_range,
                  'hl4_time': item.hl4_time
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ActivityData> _activityDataInsertionAdapter;

  final UpdateAdapter<ActivityData> _activityDataUpdateAdapter;

  final DeletionAdapter<ActivityData> _activityDataDeletionAdapter;

  @override
  Future<List<ActivityData>> findActivityData() async {
    return _queryAdapter.queryList('SELECT * from ActivityData',
        mapper: (Map<String, Object?> row) => ActivityData(
            activityReference: row['activityReference'] as int,
            name: row['name'] as String,
            date: row['date'] as String,
            avgHR: row['avgHR'] as double,
            vo2max: row['vo2max'] as double,
            calories: row['calories'] as double,
            distance: row['distance'] as double,
            distanceUnit: row['distanceUnit'] as String,
            duration: row['duration'] as double,
            activeDuration: row['activeDuration'] as double,
            speed: row['speed'] as double,
            pace: row['pace'] as String,
            hl1_range: row['hl1_range'] as String,
            hl1_time: row['hl1_time'] as double,
            hl2_range: row['hl2_range'] as String,
            hl2_time: row['hl2_time'] as double,
            hl3_range: row['hl3_range'] as String,
            hl3_time: row['hl3_time'] as double,
            hl4_range: row['hl4_range'] as String,
            hl4_time: row['hl4_time'] as double));
  }

  @override
  Future<List<ActivityData>> findActivityDataOfDay(String date) async {
    return _queryAdapter.queryList('SELECT * from ActivityData WHERE date = ?1',
        mapper: (Map<String, Object?> row) => ActivityData(
            activityReference: row['activityReference'] as int,
            name: row['name'] as String,
            date: row['date'] as String,
            avgHR: row['avgHR'] as double,
            vo2max: row['vo2max'] as double,
            calories: row['calories'] as double,
            distance: row['distance'] as double,
            distanceUnit: row['distanceUnit'] as String,
            duration: row['duration'] as double,
            activeDuration: row['activeDuration'] as double,
            speed: row['speed'] as double,
            pace: row['pace'] as String,
            hl1_range: row['hl1_range'] as String,
            hl1_time: row['hl1_time'] as double,
            hl2_range: row['hl2_range'] as String,
            hl2_time: row['hl2_time'] as double,
            hl3_range: row['hl3_range'] as String,
            hl3_time: row['hl3_time'] as double,
            hl4_range: row['hl4_range'] as String,
            hl4_time: row['hl4_time'] as double),
        arguments: [date]);
  }

  @override
  Future<void> wipeData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ActivityData');
  }

  @override
  Future<void> addActivityData(ActivityData withInfo) async {
    await _activityDataInsertionAdapter.insert(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateActivityData(ActivityData withInfo) async {
    await _activityDataUpdateAdapter.update(
        withInfo, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteActivityData(ActivityData withInfo) async {
    await _activityDataDeletionAdapter.delete(withInfo);
  }
}
