import 'package:fitfacts/screens/onboard.dart';
import 'package:flutter/material.dart';
import 'package:fitfacts/screens/homePage.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routename = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
  }//initState
  void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'logged' flag is set or not
    final sp = await SharedPreferences.getInstance();
    if(sp.getBool('logged') != null){
      //If the flag has a value, push the HomePage
      _toHomePage(context);
    }//if
  }//_checkLogin

  Future<String> _loginUser(LoginData data) async {
    if(data.name == 'name@name.com' && data.password == 'psw'){
      final sp = await SharedPreferences.getInstance();
      sp.setBool('logged', true);
      String firstLoginTime = DateTime.now().toString().replaceAll(' ', '').substring(0,16); // to be saved as encrypt key.
      sp.setString('firstLoginTime', firstLoginTime);
      print('Logged at: $firstLoginTime , (${firstLoginTime.length})');
      return '';
    } else {
      return 'Wrong credentials';
    }
  }
  // _loginUser
  Future<String> _signUpUser(SignupData data) async {
    return 'To be implemented';
  }
  // _signUpUser
  Future<String> _recoverPassword(String email) async {
    return 'Recover password functionality needs to be implemented';
  }
  // _recoverPassword
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'FitFacts',
      theme: LoginTheme(
          pageColorLight: Theme.of(context).primaryColor,
          primaryColor: Theme.of(context).primaryColor
      ),
      onLogin: _loginUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () async{
        _toOnboard(context);
      },
    );
  }
  // build
  void _toHomePage(BuildContext context){
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomePage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _toOnboard(BuildContext context){
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Onboard(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

} // LoginScreen
