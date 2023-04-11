import 'package:flutter/material.dart';
import 'package:fitfacts/navigation/Navbar.dart';


class HeartView extends StatelessWidget {
  const HeartView({Key? key}) : super(key: key);

  static const routename = 'Heart';

  @override
  Widget build(BuildContext context) {
    print('${HeartView.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart'),
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