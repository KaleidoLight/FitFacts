import 'package:fitfacts/navigation/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dob_input_field/dob_input_field.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';


class ProfilePage extends StatefulWidget {

  final String watchUser;


  ProfilePage({Key? key,  this.watchUser = 'User'}) : super(key: key);

  static const routename = 'UserPage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? gender;
  // Define a custom Form widget.
  // necessary for validation of last 3 TextFormField
  final _formKey = GlobalKey<FormState>();
  int? calculated_age;
  bool visibility = false;


  TextEditingController weightController = TextEditingController();

  TextEditingController caloriesController = TextEditingController();

  TextEditingController stepsController = TextEditingController();


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
        children:[ Form(
          key: _formKey,
          child: Column(
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
                      child: Text('$calculated_age',
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
                          color: Colors.grey[400],
                          letterSpacing: 2
                      ),
                    ),
                    SizedBox(width: 40,),
                    Text('male',
                    style: TextStyle(
                        color: Colors.grey[400],
                        letterSpacing: 2
                    ),
                    ),

                    Radio(
                      value: "male",
                      groupValue: gender,
                      onChanged: (value){
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    Text('female',
                      style: TextStyle(
                          color: Colors.grey[400],
                          letterSpacing: 2
                      ),
                    ),
                    Radio(
                      value: "female",
                      groupValue: gender,
                      onChanged: (value){
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                  ], // children
                ),
              ),

              ProfileInfo(info: 'Date of birth', icon: Icons.cake_outlined),
              
              Padding(
                padding: EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: Text("set"),
                  onPressed: () {selectDate(context);},
                  ),
                ),

              ProfileInfo(info: 'Weigth', icon: Icons.fitness_center),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller:weightController,
                        style: TextStyle(color: Colors.grey[400],
                            letterSpacing: 2),
                        enabled: true,
                        onSaved: (value){} ,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your weight';
                          } else if (int.tryParse(value) == null) {
                            return 'Please enter an integer valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            shape: const CircleBorder()),
                        child: const Icon(Icons.check))
                  ],
                ),
              ),

              ProfileInfo(info: 'Calories goal', icon: Icons.local_fire_department),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller:caloriesController,
                        style: TextStyle(color: Colors.grey[400],
                            letterSpacing: 2),
                        enabled: true,
                        onSaved: (value){} ,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your calories goal';
                          } else if (int.tryParse(value) == null) {
                            return 'Please enter an integer valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            shape: const CircleBorder()),
                        child: const Icon(Icons.check))
                  ],
                ),
              ),


              ProfileInfo(info: 'Steps goal', icon: Icons.directions_walk),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller:stepsController,
                        style: TextStyle(color: Colors.grey[400],
                            letterSpacing: 2),
                        enabled: true,
                        onSaved: (value){} ,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your step goal';
                          } else if (int.tryParse(value) == null) {
                            return 'Please enter an integer valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            shape: const CircleBorder()),
                        child: const Icon(Icons.check))
                  ],
                ),
              ),

            ],
          ),
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
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int dateYear = int.parse(currentDate.substring(0,4));
  return dateYear;
}

//date picker
selectDate(context) async {
  var datePicked = await DatePicker.showSimpleDatePicker(
                    context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1940),
                    lastDate: DateTime(currentYear()),
                    dateFormat: "dd-MMMM-yyyy",
                    locale: DateTimePickerLocale.en_us,
                    looping: true,
                    );
  return datePicked;
}

