import 'package:flutter/material.dart';
import 'package:fitfacts/screens/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routename = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final user_controller = TextEditingController(); 
  final psw_controller = TextEditingController(); 

  final String raight_user = 'user';
  final String raight_psw = 'psw';

  @override
  Widget build(BuildContext context) {
    print('${LoginPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text('FitFacts'),
        centerTitle: true,
      ),
      body: ListView( //ho usato lisview perchè column dava problemi di overflow
        children: [
          //logo image
          Padding( 
            padding: EdgeInsets.only(left:0,right:0,top:30,bottom:30),
            child: Image.asset('assets/images/logo.jpeg', width: 200, height: 200,),
          ),
          
          //text field
          Container(
              padding: EdgeInsets.only(left:30.0,right: 30.0,top:0,bottom: 0),
              
              child: Column(children: [
                TextField(
                  controller: user_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',),
                ),

                SizedBox(height: 20,),

                TextField(
                  controller: psw_controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',),
                ),],),
            ),

            //Bottons
            Container(
              padding: EdgeInsets.only(left:0,right:0,top:30,bottom: 0),
              child: Column(
                children: [
                  TextButton(
                    child: Text('LOGIN', style: TextStyle(fontSize: 20),),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blueAccent)))
                    ),
                    onPressed: () {
                      if(user_controller.text==raight_user && psw_controller.text==raight_psw){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      }else{
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                Icon( Icons.cancel, size: 50, color: Colors.red,),
                                Text("Wrong Username or Password"),],),
                            actions: <Widget>[
                              TextButton(onPressed: () {Navigator.of(context).pop();},
                                child: const Text("exit"),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        );}
                    }
                  ),

                  TextButton(
                    child: Text('Register'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text("non ho la minima idea di come si possa gestire la cosa"),
                          actions: <Widget>[
                            TextButton(onPressed: () {Navigator.of(context).pop();},
                              child: const Text("exit"),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

              ],),
            )

        ],
      ), 
    );
  } } 

