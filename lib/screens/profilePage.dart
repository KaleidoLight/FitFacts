import 'package:fitfacts/navigation/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';


class ProfilePage extends StatefulWidget {

  final String watchUser;


  ProfilePage({Key? key,  this.watchUser = 'User'}) : super(key: key);

  static const routename = 'UserPage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _fbKey = GlobalKey<FormBuilderState>();
  
  String? weigth;
  String? bornDate;
  String? calGoal;
  String? steps;
  String? gender;
  num? age;

  bool visibility = false;

  @override
  void initState() {
    bornDate = "01-January-2000";
    weigth = "0.0";
    calGoal = "0";
    steps = "10000";
    gender = null;
    age = null;
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("$bornDate"),
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
                            setState(()  {
                              bornDate = DateFormat('dd-MMMM-yyyy').format(datePicked!);
                              age = calculateAge(datePicked);
                              visibility = true;
                            },);
                          },
                        ),],
                    ),
                  ],),
                ),

              ProfileInfo(info: 'Weigth [Kg]', icon: Icons.fitness_center),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("$weigth"),
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
                                            name: "Weigth",
                                            decoration: InputDecoration(labelText: 'Weigth'),
                                            validator: FormBuilderValidators.numeric(),
                                          )
                                      ),
                                    ),],
                                ),
                              actions: <Widget>[
                                TextButton(onPressed: () {
                                  final valid = _fbKey.currentState?.saveAndValidate() ?? true;
                                  if(valid){
                                    setState(() {
                                      weigth = _fbKey.currentState?.value["Weigth"];
                                    });
                                    Navigator.of(context).pop();}else{}
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
              ),

              ProfileInfo(info: 'Calories goal [Kcal]', icon: Icons.local_fire_department),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("$calGoal"),
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
                                            name: "Calories",
                                            decoration: InputDecoration(labelText: 'Calories'),
                                            validator: FormBuilderValidators.numeric(),
                                          )
                                      ),
                                    ),],
                                ),
                              actions: <Widget>[
                                TextButton(onPressed: () {
                                  final valid = _fbKey.currentState?.saveAndValidate() ?? true;
                                  if(valid){
                                    setState(() {
                                      calGoal = _fbKey.currentState?.value["Calories"];
                                    });
                                    Navigator.of(context).pop();}else{}
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
              ),

              ProfileInfo(info: 'Steps goal', icon: Icons.directions_walk),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("$steps"),
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
                                            name: "Steps",
                                            decoration: InputDecoration(labelText: 'Steps'),
                                            validator: FormBuilderValidators.numeric(),
                                          )
                                      ),
                                    ),],
                                ),
                              actions: <Widget>[
                                TextButton(onPressed: () {
                                  final valid = _fbKey.currentState?.saveAndValidate() ?? true;
                                  if(valid){
                                    setState(() {
                                      steps = _fbKey.currentState?.value["Steps"];
                                    });
                                    Navigator.of(context).pop();}else{}
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
              ),

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

