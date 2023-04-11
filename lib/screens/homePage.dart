import 'package:flutter/material.dart';
import 'package:fitfacts/navigation/Navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built'); // REMOVE BEFORE PRODUCTION
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitFacts'),
      ),
      body: const Center(
        child: Text('nothing yet'),
      ),
      drawer: const Navbar(
        username: 'User',
        primaryColor: Colors.pink,
      ),
    );
  } //build

} 