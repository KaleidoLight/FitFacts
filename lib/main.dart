import 'package:flutter/material.dart';
import 'package:fitfacts/screens/homePage.dart';
import 'package:fitfacts/screens/loginPage.dart';
import 'package:fitfacts/screens/hearth.dart';

void main() {
  runApp(const MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This specifies the app entrypoint
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      routes: {
        '/login' : (context) => const LoginPage(),
        '/heart' : (context) => const HeartView(),
      },
    );
  } //build
}//MyApp