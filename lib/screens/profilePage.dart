import 'dart:ui';

import 'package:fitfacts/navigation/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/theme.dart';


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

  @override
  void initState() {
    super.initState();
  }//initState
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
        Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {setState(() {});},
          child: const Icon(Icons.refresh,size: 26.0,),
          )
        ),],
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
                  color: Theme.of(context).primaryColor,
                  thickness: 2,
                ),
              ),
             
              NameandAge(name: widget.watchUser, index: ageIndex),

              GenderSelector(index: genderIndex),

              ProfileInfo(info: 'Date of birth', icon: Icons.cake_outlined),
              
              BornDate(date_index: bornDateIndex, age_index: ageIndex),

              ProfileInfo(info: 'Weigth [Kg]', icon: Icons.fitness_center),
              
              UserInfoInput(name: 'Weigth', index: weigthIndex),

              ProfileInfo(info: 'Calories goal [Kcal]', icon: Icons.local_fire_department),
              
              UserInfoInput(name: 'Calories Goal', index: calGoalIndex),

              ProfileInfo(info: 'Steps goal', icon: Icons.directions_walk),
              
              UserInfoInput(name: 'Steps', index: stepsIndex),

              DateInfoItem(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text("reset"),
                    onPressed: () async {
                      final sp = await SharedPreferences.getInstance();
                      sp.remove('userInfo');
                      sp.remove('bornDate');
                      setState(() {});
                    }           
                  ),
              ],)

            ],
          ),
      ],),
    );
  }
}



//NAME AND AGE DISPLAY
class NameandAge extends StatefulWidget {
  final int index;
  final String name;
  
  const NameandAge({Key? key,
      required this.name,
      required this.index})
      : super(key: key);


  @override
  State<NameandAge> createState() => _NameandAgeState();
}

class _NameandAgeState extends State<NameandAge> {

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: EdgeInsets.all(5.0),
                child: Row( children: [
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[ Row(children: [
                    Text('Name: ',style: TextStyle(letterSpacing: 2),),
                    Text(widget.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   ],),
                  ],),
                  Spacer(),
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[ Row(children: [
                    Text('Age: ',style: TextStyle(letterSpacing: 2),),
                    FutureBuilder(
                        future: SharedPreferences.getInstance(),
                        builder: ((context, snapshot) { //snapshot = observer of the state of the features variable
                        if(snapshot.hasData){
                          final sp = snapshot.data as SharedPreferences;
                          if(sp.getStringList('userInfo') == null){ //if the string list doesn't already exist it is created
                            sp.setStringList('userInfo', List<String>.filled(6, '')); //if null inizialization
                            return const Text('',style: TextStyle(letterSpacing: 1,fontSize: 20,fontWeight: FontWeight.bold),);
                          }
                          else{ //otherwise it is readed
                            final userInfo = sp.getStringList('userInfo');
                            return Text(userInfo![widget.index],style: TextStyle(letterSpacing: 1,fontSize: 20,fontWeight: FontWeight.bold),);
                          }
                          }
                        else{
                          return CircularProgressIndicator();
                        }
                        }),
                      ),
                   ],),
                  ],),

                ],)
              );
  }
}



//GENDER

enum Gender{male, female} // Creates gender enumerator

class GenderSelector extends StatefulWidget {
  final int index;
  
  const GenderSelector({Key? key,
      required this.index})
      : super(key: key);

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {

  Gender? _gender;

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text('Gender:     ',style: TextStyle(letterSpacing: 2),),
                    
                    Text('Male',style: TextStyle(letterSpacing: 2),),

                    Radio(
                      value: Gender.male,
                      groupValue: _gender,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) async {
                        final sp = await SharedPreferences.getInstance();
                        final userInfo = sp.getStringList('userInfo');
                        setState(() {
                          userInfo![widget.index] = value.toString();
                          sp.setStringList('userInfo',userInfo);
                          _gender = Gender.male;
                        });
                      },
                    ),

                    Text('Female',style: TextStyle(letterSpacing: 2),),

                    Radio(
                      value: Gender.female,
                      groupValue: _gender,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) async {
                        final sp = await SharedPreferences.getInstance();
                        final userInfo = sp.getStringList('userInfo');
                        setState(() {
                          userInfo![widget.index] = value.toString();
                          sp.setStringList('userInfo',userInfo);
                          _gender = Gender.female;
                        });
                      },
                    ),
                  ], // children
                ),
              );
  }
}

Future<String> getGenderValue(int genderIndex)async{
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


//BORN DATE INPUT AND AGE CALCOLOUS
class BornDate extends StatefulWidget {
  final int date_index;
  final int age_index;
  
  const BornDate({Key? key,
      required this.date_index,
      required this.age_index})
      : super(key: key);


  @override
  State<BornDate> createState() => _BornDateState();
}

class _BornDateState extends State<BornDate> {

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            if(userInfo![widget.date_index]==''){ //if after the inizialization the string still empty
                              return Text('To specify');
                            }else{                //otheswise return the value of that field
                              return Text(userInfo[widget.date_index]); 
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
                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
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
                              userInfo![widget.date_index] = DateFormat('dd-MMMM-yyyy').format(datePicked!);
                              int age = calculateAge(datePicked);
                              userInfo[widget.age_index] = age.toString();
                              sp.setStringList('userInfo',userInfo);
                            },);
                          },
                        ),],
                    ),
                  ],),
                );
  }
}



//STRING OVER INPUTS DISPLAY
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



//INPUTS FIELD
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

/// DateInfoItem
///
///
class DateInfoItem extends StatefulWidget {
  const DateInfoItem({Key? key}) : super(key: key);

  @override
  State<DateInfoItem> createState() => _DateInfoItemState();
}

class _DateInfoItemState extends State<DateInfoItem> {

  @override
  Widget build(BuildContext context) {
    var themeMode = context.watch<ThemeModel>().mode;
    var greyColor = (themeMode == ThemeMode.light) ? Colors.grey[700] : Colors.grey[300];
    var bkColor = (themeMode == ThemeMode.light) ? Colors.black.withAlpha(10): Colors.white12;
    var dialogColor = (themeMode == ThemeMode.light) ? Colors.white : Colors.grey[900];
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: () async { // Open Date Selector
          var datePicked = await DatePicker.showSimpleDatePicker(
            context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1940),
            lastDate: DateTime(currentYear()),
            dateFormat: "dd MMMM yyyy",
            locale: DateTimePickerLocale.en_us,
            looping: true,
            textColor: Theme.of(context).primaryColor,
            backgroundColor: dialogColor
          );
          final sp = await SharedPreferences.getInstance();
          final userInfo =  DateFormat('dd MMMM yyyy').format(datePicked!);
          setState(()  {
            //int age = calculateAge(datePicked);
            //userInfo[widget.age_index] = age.toString();
            sp.setString('bornDate',userInfo);
          },);
        },
        child: Container(
          color: bkColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row( // Main Container
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: // Info Container
                [
                  Icon(Icons.cake_rounded, color: Theme.of(context).primaryColor,),
                  Container(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Born Date', style: TextStyle(fontSize:16, color: greyColor)),
                      Container(height: 2,),
                      FutureBuilder(
                        future: SharedPreferences.getInstance(),
                        builder: ((context, snapshot) { //snapshot = observer of the state of the features variable
                          if(snapshot.hasData){
                            final sp = snapshot.data as SharedPreferences;
                            if(sp.getString('bornDate') == null){ //if the string list doesn't already exist it is created
                              sp.setString('bornDate', '--');
                              return const Text('--',style: TextStyle(letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),);
                            }
                            else{ //otherwise it is read
                              final userInfo = sp.getString('bornDate') ?? '--';
                              return Text(userInfo,style: TextStyle(letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),);
                            }
                          }
                          else{
                            return CircularProgressIndicator();
                          }
                        }),
                      ),],)
                ],),
                Icon(Icons.edit, color: Theme.of(context).disabledColor,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

