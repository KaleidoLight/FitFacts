import 'package:flutter/material.dart';
import 'package:fitfacts/screens/loginPage.dart';

void main() {
  runApp(const MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This specifies the app entrypoint
      home: LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  } //build
}//MyApp