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

  @override
  void initState() {
    super.initState();
  }//initState
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
        Padding(
        padding: const EdgeInsets.only(right: 20.0),
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
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
        children:[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              const MainInfoItem(),

              const DateInfoItem(),
              
              const DefaultInfoItem(badgeIcon: Icons.monitor_weight_outlined, title: 'Weight', unit: '(kg)',),
              
              const DefaultInfoItem(badgeIcon: Icons.local_fire_department_rounded, title: 'Calories Goal', unit: '(kCal)',),

              const DefaultInfoItem(badgeIcon: Icons.directions_walk_rounded, title: 'Steps Goal',),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text("reset"),
                    onPressed: () async {
                      final sp = await SharedPreferences.getInstance();
                      sp.clear();
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


/// Age Calculator
///
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


/// Today Getter
///
int currentYear(){
  String currentDate = DateFormat('yyyy-MMMM-dd').format(DateTime.now());
  int dateYear = int.parse(currentDate.substring(0,4));
  return dateYear;
}


/// #### DateInfoItem
/// Draws date-picker widget
///
class DateInfoItem extends StatefulWidget {
  const DateInfoItem({Key? key}) : super(key: key);

  @override
  State<DateInfoItem> createState() => _DateInfoItemState();
}

class _DateInfoItemState extends State<DateInfoItem> {

  @override
  Widget build(BuildContext context) {

    // Theme Variables
    var themeMode = context.watch<ThemeModel>().mode;
    var greyColor = (themeMode == ThemeMode.light) ? Colors.grey[700] : Colors.grey[300];
    var bkColor = (themeMode == ThemeMode.light) ? Colors.black.withAlpha(10): Colors.white12;
    var dialogColor = (themeMode == ThemeMode.light) ? Colors.white : Colors.grey[900];

    // View Builder
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
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
              int age = calculateAge(datePicked);
              sp.setString('age', age.toString());
              sp.setString('bornDate',userInfo);
            },);
          }, // end on-tap
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
                                final userAge = sp.getString('age') ?? '--';
                                return Row(
                                  children: [
                                    Text(userInfo,style: const TextStyle(letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),),
                                    Container(width: 3,),
                                    Text('($userAge yo)', style: const TextStyle(fontSize: 16,),)
                                  ],
                                );
                              }
                            }
                            else{
                              return const CircularProgressIndicator();
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
      ),
    );
  }
}

/// #### Default Info Item
/// Draws default info item widget
///
/// [badgeIcon]: The Icon representing the Measure
///
/// [title]: The Title of the Measure
///
/// [unit]: The unit of the Measure (optional)
class DefaultInfoItem extends StatefulWidget {

  final IconData badgeIcon;
  final String title;
  final String unit;

  const DefaultInfoItem({Key? key, required this.badgeIcon, required this.title, this.unit = ''}) : super(key: key);

  @override
  State<DefaultInfoItem> createState() => _DefaultInfoItemState();
}

class _DefaultInfoItemState extends State<DefaultInfoItem> {

  @override
  Widget build(BuildContext context) {

    // Theme Variables
    var themeMode = context.watch<ThemeModel>().mode;
    var greyColor = (themeMode == ThemeMode.light) ? Colors.grey[700] : Colors.grey[300];
    var bkColor = (themeMode == ThemeMode.light) ? Colors.black.withAlpha(10): Colors.white12;

    final _fbKey = GlobalKey<FormBuilderState>();
    
    // View Builder
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          onTap: () async { // Open Date Selector
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(
                      width: 2*(MediaQuery.of(context).size.width)/3,
                      child: FormBuilder(
                          key:  _fbKey,
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: () {
                            _fbKey.currentState!.save();
                          },
                          child:
                          FormBuilderTextField(
                            name: widget.title,
                            decoration: InputDecoration(labelText: widget.title),
                            validator: FormBuilderValidators.numeric(),
                          )
                      ),
                    ),],
                ),
                actions: <Widget>[
                  TextButton(onPressed: (){Navigator.of(context).pop();},
                  child: const Text('Cancel'),),
                  TextButton(onPressed: () async {
                    final valid = _fbKey.currentState?.saveAndValidate() ?? true;
                    if(valid) {
                      final sp = await SharedPreferences.getInstance();
                      setState(() {
                        //userInfo![widget.title] = _fbKey.currentState?.value[widget.title];
                        sp.setString(widget.title,_fbKey.currentState?.value[widget.title]);});
                      Navigator.of(context).pop();
                    }
                  },
                    child: const Text("Save"),
                    ),
                ],
              ),);
          }, // end on-tap
          child: Container(
            color: bkColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row( // Main Container
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: // Info Container
                  [
                    Icon(widget.badgeIcon, color: Theme.of(context).primaryColor,),
                    Container(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.title, style: TextStyle(fontSize:16, color: greyColor)),
                            Container(width: 5,),
                            Text(widget.unit, style: TextStyle(fontSize:16, color: greyColor))
                          ],
                        ),
                        Container(height: 2,),
                        FutureBuilder(
                          future: SharedPreferences.getInstance(),
                          builder: ((context, snapshot) { //snapshot = observer of the state of the features variable
                            if(snapshot.hasData){
                              final sp = snapshot.data as SharedPreferences;
                              if(sp.getString(widget.title) == null){ //if the string list doesn't already exist it is created
                                sp.setString(widget.title, '--');
                                return const Text('--',style: TextStyle(letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),);
                              }
                              else{ //otherwise it is read
                                final userInfo = sp.getString(widget.title) ?? '--';
                                return Text(userInfo,style: const TextStyle(letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),);
                              }
                            }
                            else{
                              return const CircularProgressIndicator();
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
      ),
    );
  }
}

/// #### [MainInfoItem]
///
/// Draws the header widget for the profile page
///
///
class MainInfoItem extends StatefulWidget {
  const MainInfoItem({Key? key}) : super(key: key);

  @override
  State<MainInfoItem> createState() => _MainInfoItemState();
}

class _MainInfoItemState extends State<MainInfoItem> {
  @override
  Widget build(BuildContext context) {

    // Theme Variables
    var themeMode = context.watch<ThemeModel>().mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.black.withAlpha(10): Colors.white12;

    final _fbKey = GlobalKey<FormBuilderState>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: bkColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: SharedPreferences.getInstance(),
                            builder: (context, snapshot){
                              if (snapshot.hasData){
                                final sp = snapshot.data as SharedPreferences;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(sp.getString('Username') ?? '--', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                    Container(width: 5,),
                                    Icon((sp.getString('Gender') == 'Male') ? Icons.male_rounded : Icons.female_rounded, size: 22, color: Colors.grey[600],),
                                  ],
                                );
                              }else {
                                return const CircularProgressIndicator();
                              }
                            }
                          ),
                          Container(height: 3,),
                          const Text('name.surname@fit.com', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),),
                          Container(height: 10,),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                child: OutlinedButton(
                                    onPressed:  (){
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Container(
                                            constraints: const BoxConstraints(maxHeight: 180),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children:[
                                                    SizedBox(
                                                      width: 2*(MediaQuery.of(context).size.width)/3,
                                                      child: FormBuilder(
                                                          key:  _fbKey,
                                                          autovalidateMode: AutovalidateMode.always,
                                                          onChanged: () {
                                                            _fbKey.currentState!.save();
                                                          },
                                                          child:
                                                          FutureBuilder(
                                                            future: SharedPreferences.getInstance(),
                                                            builder: (context, snapshot){
                                                              if (snapshot.hasData){
                                                                final sp = snapshot.data as SharedPreferences;
                                                                sp.setString('Gender', 'Male');
                                                                return FormBuilderTextField(
                                                                  name: 'Username',
                                                                  decoration: const InputDecoration(labelText: 'Username'),
                                                                  validator: FormBuilderValidators.required(),
                                                                  initialValue: sp.getString('Username')
                                                                );
                                                              }else{
                                                                return const CircularProgressIndicator();
                                                              }
                                                            },
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                GenderSelectionWidget(),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(onPressed: (){Navigator.of(context).pop();},
                                              child: const Text('Cancel'),),
                                            TextButton(onPressed: () async {
                                              final valid = _fbKey.currentState?.saveAndValidate() ?? true;
                                              if(valid) {
                                                final sp = await SharedPreferences.getInstance();
                                                setState(() {
                                                  //userInfo![widget.title] = _fbKey.currentState?.value[widget.title];
                                                  sp.setString('Username',_fbKey.currentState?.value['Username']);});
                                                Navigator.of(context).pop();
                                              }
                                            },
                                              child: const Text("Save"),
                                            ),
                                          ],
                                        ),);
                                    },
                                    style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
                                    child: Row(
                                      children: [const Icon(Icons.edit), Container(width: 5,), Text('Edit')],
                                )),
                              ),
                              Container(width: 5,),
                              Container(
                                child: OutlinedButton(
                                    onPressed: (){ // Edit Button Action
                                    },
                                    style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
                                    child: Row(
                                      children: const [Icon(Icons.power_settings_new_rounded)],
                                )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ) ),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                        backgroundColor: Colors.purple[50],
                        radius: 60,
                        child: Icon(Icons.account_circle_rounded, color: Colors.black.withAlpha(50), size: 70,),
                      )
                    ],) )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// #### [GenderSelectionWidget]
///
/// Displays selector for gender
///
class GenderSelectionWidget extends StatefulWidget {
  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {

  String selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 25,),
        const Text('Gender', style: TextStyle(fontSize: 18),),
        Row(
        children: [
          Radio<String>(
            value: 'Male',
            groupValue: selectedGender,
            onChanged: (value) async {
              final sp = await SharedPreferences.getInstance();
              setState(() {
                selectedGender = value!;
                sp.setString('Gender', value);
              });
            },
          ),
          const Text('Male'),
          Radio<String>(
            value: 'Female',
            groupValue: selectedGender,
            onChanged: (value) async {
              final sp = await SharedPreferences.getInstance();
              setState(() {
                selectedGender = value!;
                sp.setString('Gender', value);
              });
            },
          ),
          const Text('Female'),
        ],
      ),
    ]);
  }
}