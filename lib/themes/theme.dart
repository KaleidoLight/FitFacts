import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/services.dart';


/// LIGHT THEME
ThemeData appLight = FlexThemeData.light(scheme: FlexScheme.deepPurple).copyWith(
  //primaryColor: Colors.blue[400],
  appBarTheme:  AppBarTheme(
      backgroundColor: Colors.purple[900],
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      )
  ),

);

/// DARK THEME
ThemeData appDark = FlexThemeData.dark(scheme: FlexScheme.deepPurple).copyWith(
    primaryColor: Colors.purple[100],
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white12,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        )
    )
);


/// THEME MODE SELECTOR PROVIDER
///
/// #### Functionalities
/// Toggles between **[appLight]** and **[appDark]** themes
/// and updates the view accordingly.
class ThemeModel with ChangeNotifier{
  ThemeMode _mode;
  ThemeMode get mode => _mode;

  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode(){
    _mode = (_mode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

