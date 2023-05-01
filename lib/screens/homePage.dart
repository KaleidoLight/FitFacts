import 'package:flutter/material.dart';
import 'package:fitfacts/navigation/navbar.dart';

import 'package:fitfacts/model/userInfo.dart';
import 'package:provider/provider.dart';

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
      body: Center(
        child: //Text('nothing yet'),
          Consumer<UserInfo>(   
            builder: (context, userInfo, child) {
               return Text(userInfo.Info['weigth']);
            },),
      ),
      drawer: const Navbar(
        username: 'User',
      ),
    );
  } //build

} 