import 'package:flutter/material.dart';
import 'package:fitfacts/screens/homePage.dart';
import 'package:fitfacts/screens/loginPage.dart';
import 'package:fitfacts/screens/profilePage.dart';
import 'package:fitfacts/screens/hearth.dart';
import 'package:fitfacts/themes/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MyApp());
} //main

class MyApp extends StatelessWidget {
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
            home: const LoginPage(),
            routes: {
              '/home' : (context) => const HomePage(),
              '/heart' : (context) => const HeartView(),
              '/profile' : (context) => ProfilePage(),
            },
          );
        },
      ),
    );
  }
}
