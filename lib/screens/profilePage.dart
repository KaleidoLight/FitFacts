import 'package:fitfacts/navigation/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfilePage extends StatefulWidget {

  final String watchUser;


  ProfilePage({Key? key,  this.watchUser = 'User'}) : super(key: key);

  static const routename = 'UserPage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final int bornDateIndex = 0; //index of the persistance string list 
  final int ageIndex = 1;
  final int genderIndex = 2;
  final int weigthIndex = 3;
  final int calGoalIndex = 4;
  final int stepsIndex = 5;
  
  //String? weigth;
  String? gender;
  num? age;

  bool visibility = false;

  @override
  void initState() {
    visibility = false;
    super.initState();
  }//initState
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: const Navbar(
        username: 'User',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
        children:[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.jpeg'),
                    radius: 60,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Divider(
                  color: Colors.grey[800],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  'Name',
                  style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text(
                      ' ${widget.watchUser} ',
                      style: const TextStyle(
                          color: Colors.pinkAccent,
                          letterSpacing: 2,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 180,),

                    AnimatedOpacity(
                      opacity: visibility ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Text('$age',
                      style: const TextStyle(
                          color: Colors.pinkAccent,
                          letterSpacing: 2,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                    )

                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text('gender: ',
                      style: TextStyle(
                          letterSpacing: 2
                      ),
                    ),
                    SizedBox(width: 40,),
                    Text('male',
                    style: TextStyle(
                        letterSpacing: 2
                    ),
                    ),
                    Radio(
                      value: 'male',
                      groupValue: getGenderValue(genderIndex),
                      onChanged: (value) async {
                        final sp = await SharedPreferences.getInstance();
                        final userInfo = sp.getStringList('userInfo');
                        setState(() {
                          userInfo![genderIndex] = value.toString();
                          sp.setStringList('userInfo',userInfo);
                        });
                      },
                    ),
                    Text('female',
                      style: TextStyle(
                          letterSpacing: 2
                      ),
                    ),
                    Radio(
                      value: 'female',
                      groupValue: getGenderValue(genderIndex),
                      onChanged: (value) async {
                        final sp = await SharedPreferences.getInstance();
                        final userInfo = sp.getStringList('userInfo');
                        setState(() {
                          userInfo![genderIndex] = value.toString();
                          sp.setStringList('userInfo',userInfo);
                        });
                      },
                    ),
                  ], // children
                ),
              ),

              ProfileInfo(info: 'Date of birth', icon: Icons.cake_outlined),
              
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                        future: SharedPreferences.getInstance(),
                        builder: ((context, snapshot) { //snapshot = observer of the state of the features variable
                        if(snapshot.hasData){
                          final sp = snapshot.data as SharedPreferences;
                          if(sp.getStringList('userInfo') == null){ //if the string list doesn't already exist it is created
                            sp.setStringList('userInfo', List<String>.filled(6, '')); //if null inizialization
                            return Text('To specify');
                          }
                          else{ //otherwise it is readed
                            final userInfo = sp.getStringList('userInfo');
                            if(userInfo![bornDateIndex]==''){ //if after the inizialization the string still empty
                              return Text('To specify');
                            }else{                //otheswise return the value of that field
                              return Text(userInfo[bornDateIndex]); 
                            }
                          }
                        }
                        else{
                          return CircularProgressIndicator();
                        }
                        }),
                      ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [ 
                        ElevatedButton(
                          child: Text("set"),
                          onPressed: () async {
                            var datePicked = await DatePicker.showSimpleDatePicker(
                                context,
                                initialDate: DateTime(2000),
                                firstDate: DateTime(1940),
                                lastDate: DateTime(currentYear()),
                                dateFormat: "dd-MMMM-yyyy",
                                locale: DateTimePickerLocale.en_us,
                                looping: true,
                              );
                            final sp = await SharedPreferences.getInstance();
                            final userInfo = sp.getStringList('userInfo');
                            setState(()  {
                              userInfo![bornDateIndex] = DateFormat('dd-MMMM-yyyy').format(datePicked!);
                              age = calculateAge(datePicked);
                              userInfo[ageIndex] = age.toString();
                              sp.setStringList('userInfo',userInfo);
                              visibility = true;
                            },);
                          },
                        ),],
                    ),
                  ],),
                ),

              ProfileInfo(info: 'Weigth [Kg]', icon: Icons.fitness_center),
              
              UserInfoInput(name: 'Weigth', index: weigthIndex),

              ProfileInfo(info: 'Calories goal [Kcal]', icon: Icons.local_fire_department),
              
              UserInfoInput(name: 'Calories Goal', index: calGoalIndex),

              ProfileInfo(info: 'Steps goal', icon: Icons.directions_walk),
              
              UserInfoInput(name: 'Steps', index: stepsIndex),

            ],
          ),
      ],),
    );
  }
}

class ProfileInfo extends StatelessWidget{
  final String info;
  final IconData icon;

  const ProfileInfo({required this.info, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon,),
          const SizedBox(width: 10,),
          Text(info,
            style: TextStyle(letterSpacing: 2),),
          ],
        ),
      );
  }
}

//calculate the age
calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;  // is the current year - 1
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) { // until the day before birthday
      age--;
    }
  }
  
  return age;
}

//prende la data corrente per ottenere l'anno corrente per la data di nascita
int currentYear(){
  String currentDate = DateFormat('yyyy-MMMM-dd').format(DateTime.now());
  int dateYear = int.parse(currentDate.substring(0,4));
  return dateYear;
}

class UserInfoInput extends StatefulWidget {
  final int index;
  final String name;
  
  const UserInfoInput({Key? key,
      required this.name,
      required this.index})
      : super(key: key);


  @override
  State<UserInfoInput> createState() => _UserInfoInputState();
}

class _UserInfoInputState extends State<UserInfoInput> {
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: SharedPreferences.getInstance(),
                        builder: ((context, snapshot) { //snapshot = observer of the state of the features variable
                        if(snapshot.hasData){
                          final sp = snapshot.data as SharedPreferences;
                          if(sp.getStringList('userInfo') == null){
                            sp.setStringList('userInfo', List<String>.filled(6, '')); //if null inizialization
                            return Text('To specify');
                          }
                          else{ 
                            //sp.remove('userInfo'); scommentare se si vuole ripulire la memoria
                            final userInfo = sp.getStringList('userInfo');
                            if(userInfo![widget.index]==''){ //if after the inizialization the string still empty
                              return Text('To specify');
                            }else{                //otheswise return the value of that field
                              return Text(userInfo[widget.index]); 
                            }
                          }
                        }
                        else{
                          return CircularProgressIndicator();
                        }
                        }),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [ 
                      ElevatedButton(
                        child: Text("set"),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  SizedBox(
                                    width: 250,
                                    child: FormBuilder(
                                      key:  _fbKey,
                                      autovalidateMode: AutovalidateMode.always,
                                      onChanged: () {
                                        _fbKey.currentState!.save();
                                      },
                                      child:
                                        FormBuilderTextField(
                                          name: widget.name,
                                          decoration: InputDecoration(labelText: widget.name),
                                          validator: FormBuilderValidators.numeric(),
                                        )
                                    ),
                                  ),],
                              ),
                            actions: <Widget>[
                              TextButton(onPressed: () async {
                                final valid = _fbKey.currentState?.saveAndValidate() ?? true;
                                if(valid) {
                                  final sp = await SharedPreferences.getInstance();
                                  final userInfo = sp.getStringList('userInfo');
                                  setState(() {
                                    userInfo![widget.index] = _fbKey.currentState?.value[widget.name];
                                    sp.setStringList('userInfo',userInfo);});
                                  Navigator.of(context).pop();
                                  }else{}
                                },
                                child: const Text("save"),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                ),
                              ),
                            ],
                            ),);
                        },
                      ),],
                  ),
                ],
              ),
            );
  }
}

Future<String> getGenderValue_future(int genderIndex)async{
  String? gender;
  final sp = await SharedPreferences.getInstance();
  final userInfo = sp.getStringList('userInfo');
  if(userInfo == null){
    sp.setStringList('userInfo', List<String>.filled(6, '')); //if null inizialization
    gender = '';
  }else{
    gender = userInfo[genderIndex];
  }
  return gender;
}

String? getGenderValue(genderIndex){
  Future.wait([getGenderValue_future(genderIndex)]).then((value) {print(value[0]); return value[0];});
}