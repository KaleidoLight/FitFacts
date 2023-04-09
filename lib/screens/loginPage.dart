import 'package:flutter/material.dart';
import 'package:fitfacts/screens/homePage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routename = 'LoginPage';

  @override
  Widget build(BuildContext context) {
    print('${LoginPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text('FitFacts'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //logo image
          Image.asset('assets/images/logo.jpeg', width: 100, height: 100,),
          
          //text field
          Padding(
              padding: EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',),
              ),
            ),

            //floating botton
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                child: Text('LOGIN'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ),
        ],
      ), 
    );
  } //build

} 

