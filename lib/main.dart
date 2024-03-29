import 'package:fitfacts/screens/calories.dart';
import 'package:fitfacts/screens/loginPage.dart';
import 'package:fitfacts/screens/sleep.dart';
import 'package:fitfacts/screens/steps.dart';
import 'package:flutter/material.dart';
import 'package:fitfacts/screens/homePage.dart';
import 'package:fitfacts/screens/profilePage.dart';
import 'package:fitfacts/screens/hearth.dart';
import 'package:fitfacts/screens/activity.dart';
import 'package:fitfacts/themes/theme.dart';
import 'package:provider/provider.dart';
import 'database/Database.dart';
import 'database/DatabaseRepo.dart';

Future<void> main() async {

  //This is a special method that use WidgetFlutterBinding to interact with the Flutter engine.
  //This is needed when you need to interact with the native core of the app.
  //Here, we need it since when need to initialize the DB before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  //This opens the database.
  final AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);

  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: const MyApp(),
  ));

} //main

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_, model, __) {
          return MaterialApp(
            theme: appLight, // Provide light theme.
            darkTheme: appDark, // Provide dark theme.
            themeMode: model.mode, // Decides which theme to show.
            home:  const LoginPage(),
            routes: {
              '/home' : (context) => const HomePage(),
              '/heart' : (context) => const HeartPage(),
              '/profile' : (context) => const ProfilePage(),
              '/sleep' : (context) => const SleepPage(),
              '/calories' : (context) => const CaloriesPage(),
              '/steps' : (context) => const StepsPage(),
              '/activity' : (context) => const ActivityPage()
            },
          );
        },
      ),
    );
  }
}
