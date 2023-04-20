import 'package:flutter/material.dart';
import 'package:fitfacts/navigation/navbar.dart';


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
      ),
    );
  } //build

}