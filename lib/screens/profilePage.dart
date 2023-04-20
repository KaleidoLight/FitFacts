
import 'package:flutter/material.dart';
import 'package:dob_input_field/dob_input_field.dart';


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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Info'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.jpeg'),
                  radius: 60,
                ),
              ),
              Divider(
                height: 60,
                color: Colors.grey[800],
              ),
              const Text(
                'Name',
                style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2
                ),
              ),
              const SizedBox(height: 10),
              Row(
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



              const SizedBox(height: 10),



              Row(
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



              SizedBox(height: 10,),
              Row(
                children: [
                  Icon(
                  Icons.cake_outlined,
                  color: Colors.grey[400],
                ),
                  const SizedBox(
                    width: 20,
                  ),

                  const Text(
                    'Date of birth',
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5,),
              DOBInputField(
                firstDate: DateTime(1900),
                // showLabel: true,
                // fieldLabelText: "please insert your date of birth",
                lastDate:DateTime.now() ,
                inputDecoration: const InputDecoration(filled: false,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'DD/MM/YYYY'),
                cursorColor: Colors.pinkAccent,
                autovalidateMode: AutovalidateMode.always,
                style: const TextStyle(color: Colors.grey,
                    letterSpacing: 2),
                dateFormatType: DateFormatType.DDMMYYYY,
                onDateSaved: (value){
                }, // to call the final date
                onDateSubmitted: (value){
                  final age = calculateAge(value);
                  print('$age');
                  setState(() {
                    calculated_age = age;
                    visibility = true;
                  });
                },
              ),


              const SizedBox(height: 20,),
              Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'weigth',
                    style: TextStyle(
                        color: Colors.grey[400],
                        letterSpacing: 2
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 305,
                    child: TextFormField(
                      controller:weightController,
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




              SizedBox(height: 20,),
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'calories goal',
                    style: TextStyle(
                        color: Colors.grey[400],
                        letterSpacing: 2
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 305,
                    child: TextFormField(
                      controller:caloriesController,
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




              SizedBox(height: 20,),
              Row(
                children: [
                  Icon(
                    Icons.directions_walk,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'steps goal',
                    style: TextStyle(
                        color: Colors.grey[400],
                        letterSpacing: 2
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 305,
                    child: TextFormField(
                      controller:stepsController,
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

            ],
          ),
        ),
      ),
    );
  }
}


// for calculating age

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




