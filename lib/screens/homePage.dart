import 'package:flutter/material.dart';
import 'package:fitfacts/screens/loginPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text('FitFacts'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded( 
              child: ListView(
                 // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue,),
                    accountName: Text("Username",style: TextStyle(fontWeight: FontWeight.bold,),),
                    accountEmail: Text("Usename.surname@gmail.com",style: TextStyle(fontWeight: FontWeight.bold,),),
                    currentAccountPicture: Icon( Icons.account_circle, size: 100,),
                  ),
            
                  ListTile(
                    leading: Icon( Icons.home, ),
                    title: const Text('Home Page'),
                    onTap: () {Navigator.pop(context);},
                  ),
                ],
              ),),
            
            Expanded( //uso due expanded così da poter posizionare il tasto di logout in fondo al drawer
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.exit_to_app),
                  label: Text('LOGOUT'),
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));   
                  },
                ),
              ),
            ),
          ],),
        ),
      
      body: Center(
        child: Text('nothing yet'),
      ), 
    );
  } //build

} 