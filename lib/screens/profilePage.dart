import 'package:fitfacts/database/DatabaseRepo.dart';
import 'package:fitfacts/database/UserInfo.dart';
import 'package:fitfacts/navigation/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../server/NetworkUtils.dart';
import '../themes/theme.dart';
import 'loginPage.dart';


class ProfilePage extends StatefulWidget {

  final String watchUser;

  const ProfilePage({Key? key,  this.watchUser = 'User'}) : super(key: key);

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
      ),
      drawer: const Navbar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
        children:[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              MainInfoItem(),

              DateInfoItem(),
              
              DefaultInfoItem(badgeIcon: Icons.monitor_weight_outlined, title: 'Weight', unit: '(kg)', queryString: 'Weight',),

              DefaultInfoItem(badgeIcon: Icons.height_outlined, title: 'Height', unit: '(cm)', queryString: 'Height',),
              
              DefaultInfoItem(badgeIcon: Icons.local_fire_department_rounded, title: 'Calories Goal', unit: '(kCal)', queryString: 'CalorieGoal'),

              DefaultInfoItem(badgeIcon: Icons.directions_walk_rounded, title: 'Steps Goal', queryString: 'StepGoal',),
            ],
          ),
      ],),
    );
  }
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
              dateFormat: "dd-MM-yyyy",
              locale: DateTimePickerLocale.en_us,
              looping: true,
              textColor: Theme.of(context).primaryColor,
              backgroundColor: dialogColor
            );
            final userInfo =  DateFormat('dd-MM-yyyy').format(datePicked!);
            setState(()  {
              Provider.of<DatabaseRepository>(context, listen: false).updateUserInfo((instance) {
                instance.birthDay = userInfo;
              });
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
                        Consumer<DatabaseRepository>(
                          builder: (context, drb, child){
                            return FutureBuilder(
                              future: Provider.of<DatabaseRepository>(context).queryUserInfo('Birthday'),
                              builder: ((context, snapshot) { //snapshot = observer of the state of the features variable
                                if(snapshot.hasData){
                                  final sp = snapshot.data as String;
                                  dynamic dateDisp = calculateStringAge(sp);
                                  dateDisp??= '';
                                  return Row(
                                    children: [
                                      Text(sp,style: const TextStyle(letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),),
                                      Container(width: 3,),
                                      Text('($dateDisp yo)', style: const TextStyle(fontSize: 16,),)
                                      ],
                                    );
                                }
                                else{
                                  return const Text('--');
                                }
                              }),
                            );
                          },
                        )
                      ],)
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

enum Validators{
   required,
   numeric,
}

class DefaultInfoItem extends StatefulWidget {

  final IconData badgeIcon;
  final String title;
  final String unit;
  final Validators validator;
  final String queryString;

  const DefaultInfoItem({Key? key, required this.badgeIcon, required this.title, this.unit = '', this.validator =  Validators.numeric, required this.queryString}) : super(key: key);

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

    final fbKey = GlobalKey<FormBuilderState>();
    
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
                          key:  fbKey,
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: () {
                            fbKey.currentState!.save();
                          },
                          child:
                          FormBuilderTextField(
                            name: widget.title,
                            decoration: InputDecoration(labelText: widget.title),
                            validator: (widget.validator == Validators.numeric) ? FormBuilderValidators.numeric() : FormBuilderValidators.required(),
                          )
                      ),
                    ),],
                ),
                actions: <Widget>[
                  TextButton(onPressed: (){Navigator.of(context).pop();},
                    child: const Text('Cancel'),),
                  TextButton(onPressed: () async {
                    final valid = fbKey.currentState?.saveAndValidate() ?? true;
                    if(valid) {
                      setState(() {
                        Provider.of<DatabaseRepository>(context, listen: false).updateUserInfo((instance) {
                          if (widget.queryString == 'Username'){
                            instance.username = fbKey.currentState?.value[widget.title];
                          } else if (widget.queryString == 'Birthday'){
                            instance.birthDay = fbKey.currentState?.value[widget.title];
                          } else if (widget.queryString == 'CalorieGoal') {
                            instance.calorieGoal = int.parse(fbKey.currentState?.value[widget.title]);
                          } else if (widget.queryString == 'StepGoal'){
                            instance.stepGoal = int.parse(fbKey.currentState?.value[widget.title]);
                          } else if (widget.queryString == 'Weight'){
                            instance.weight = int.parse(fbKey.currentState?.value[widget.title]);
                          } else if (widget.queryString == 'Height'){
                            instance.height = int.parse(fbKey.currentState?.value[widget.title]);
                          }
                        });
                      });
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
                        Consumer<DatabaseRepository>(
                          builder: (context, dbr, child){
                            return FutureBuilder(
                              future: Provider.of<DatabaseRepository>(context).queryUserInfo(widget.queryString),
                              builder: ((context, snapshot) { //snapshot = observer of the state of the features variable
                                if(snapshot.hasData){
                                  final sp = snapshot.data;
                                  return Text('$sp',style: const TextStyle(letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),);
                                }
                                else{
                                  return const Text('--');
                                }
                              }),
                            );
                          },
                        )
                      ],)
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

    final fbKey = GlobalKey<FormBuilderState>();

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
                          Consumer<DatabaseRepository>(
                            builder: (context, dbr, child){
                            return FutureBuilder(
                              future: Provider.of<DatabaseRepository>(context).findUser(),
                              builder: (context, snapshot){
                                if (snapshot.hasData){
                                  final sp = snapshot.data as UserInfo;
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(sp.username, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                      Container(width: 5,),
                                      Icon((sp.sex == 'Male') ? Icons.male_rounded : Icons.female_rounded, size: 22, color: Colors.grey[600],),
                                    ],
                                  );
                                }else {
                                  return const Text('--');
                                }
                              }
                            );}
                          ),
                          Container(height: 3,),
                          const Text('demo@fitfacts.com', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),),
                          Container(height: 10,),
                          Row(
                            children: [
                              SizedBox(
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
                                                          key:  fbKey,
                                                          autovalidateMode: AutovalidateMode.always,
                                                          onChanged: () {
                                                            fbKey.currentState!.save();
                                                          },
                                                          child:
                                                          Consumer<DatabaseRepository>(
                                                            builder: (context, dbr, child){
                                                              return FutureBuilder(
                                                                future: Provider.of<DatabaseRepository>(context).queryUserInfo('Username'),
                                                                builder: (context, snapshot){
                                                                  if (snapshot.hasData){
                                                                    final sp = snapshot.data as String;
                                                                    return FormBuilderTextField(
                                                                        name: 'Username',
                                                                        decoration: const InputDecoration(labelText: 'Username'),
                                                                        validator: FormBuilderValidators.required(),
                                                                        initialValue: sp
                                                                    );
                                                                  }else{
                                                                    return const Text('--');
                                                                  }
                                                                },
                                                              );
                                                            }
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const GenderSelectionWidget(),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(onPressed: (){Navigator.of(context).pop();},
                                              child: const Text('Cancel'),),
                                            TextButton(onPressed: () async {
                                              final valid = fbKey.currentState?.saveAndValidate() ?? true;
                                              if(valid) {
                                                setState(() {
                                                  Provider.of<DatabaseRepository>(context, listen: false).updateUserInfo((instance) {
                                                    instance.username = fbKey.currentState?.value['Username'] as String;
                                                  });
                                                });
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
                                      children: [const Icon(Icons.edit), Container(width: 5,), const Text('Edit')],
                                )),
                              ),
                              Container(width: 5,),
                              OutlinedButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return SignOutAlertDialog();
                                    }).then((value) async {
                                      if (value != null && value == true) {
                                        await Provider.of<DatabaseRepository>(context, listen: false).wipeDatabase();
                                        clearSharedPreferences();
                                        _toLoginPage(context);
                                      } else {
                                        // User canceled sign out
                                      }
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
                                  child: Row(
                                    children: const [Icon(Icons.logout)],
                              )),
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
                        foregroundImage: Image.asset('assets/images/profilePic.png').image,
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

  const GenderSelectionWidget({super.key});
  @override
  State<GenderSelectionWidget> createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  String selectedGender = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedGender();
  }

  Future<void> _loadSelectedGender() async {
    final gender = await Provider.of<DatabaseRepository>(context, listen: false).getSex();
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 25),
        const Text(
          'Gender',
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: selectedGender,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                  Provider.of<DatabaseRepository>(context, listen: false).updateUserInfo((instance) {
                    instance.sex = 'Male';
                  });
                });
              },
            ),
            const Text('Male'),
            Radio<String>(
              value: 'Female',
              groupValue: selectedGender,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                  Provider.of<DatabaseRepository>(context, listen: false).updateUserInfo((instance) {
                    instance.sex = 'Female';
                  });
                });
              },
            ),
            const Text('Female'),
          ],
        ),
      ],
    );
  }
}

/// #### GenderSelectorStyled
///
/// [badgeIcon]: The Icon representing the Measure
///
/// [title]: The Title of the Measure
///
/// [unit]: The unit of the Measure (optional)
class GenderSelectorStyled extends StatefulWidget {

  final IconData badgeIcon;
  final String title;
  final String unit;

  const GenderSelectorStyled({Key? key, required this.badgeIcon, required this.title, this.unit = ''}) : super(key: key);

  @override
  State<GenderSelectorStyled> createState() => _GenderSelectorStyledState();
}

class _GenderSelectorStyledState extends State<GenderSelectorStyled> {

  @override
  Widget build(BuildContext context) {

    // Theme Variables
    var themeMode = context.watch<ThemeModel>().mode;
    var greyColor = (themeMode == ThemeMode.light) ? Colors.grey[700] : Colors.grey[300];
    var bkColor = (themeMode == ThemeMode.light) ? Colors.black.withAlpha(10): Colors.white12;

    final fbKey = GlobalKey<FormBuilderState>();

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
                content: Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child:const GenderSelectionWidget()),
                actions: <Widget>[
                  TextButton(onPressed: (){Navigator.of(context).pop();},
                    child: const Text('Cancel'),),
                  TextButton(onPressed: () async {
                    final valid = fbKey.currentState?.saveAndValidate() ?? true;
                    if(valid) {
                      setState(() {});
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
                    Icon(Icons.transgender_rounded, color: Theme.of(context).primaryColor,),
                    Container(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Gender', style: TextStyle(fontSize:16, color: greyColor)),
                          ],
                        ),
                        Container(height: 2,),
                        Consumer<DatabaseRepository>(
                          builder: (context, dbr, child){
                            return FutureBuilder(
                              future: Provider.of<DatabaseRepository>(context).getSex(),
                              builder: ((context, snapshot) { //snapshot = observer of the state of the features variable
                                if(snapshot.hasData){
                                    return Text(snapshot.data as String, style: const TextStyle(letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),);
                                }
                                else{
                                  return const Text('--');
                                }
                              }),
                            );
                          },
                        )
                      ],)
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


int? calculateStringAge(String birthday) {
  // Parse the birthday string to a DateTime object
  DateTime birthDate = DateFormat('dd-MM-yyyy').parse(birthday);
  // Get the current date
  DateTime currentDate = DateTime.now();

  // Calculate the difference between the current date and the birth date
  Duration difference = currentDate.difference(birthDate);

  // Convert the difference to years and return it as an integer
  int age = (difference.inDays / 365).floor();
  if (age <= 110) {
    return age;
  }else{
    return null;
  }
}

/// SignOutVerification
///
class SignOutAlertDialog extends StatelessWidget {

  const SignOutAlertDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure?\nYou will also be disconnected from your Fitbit',
        textAlign: TextAlign.center,),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false); // Return false when cancel button is pressed
          },
        ),
        TextButton(
          child: const Text('Sign Out', style: TextStyle(color: Colors.red), selectionColor: Colors.red),
          onPressed: () {
            Navigator.of(context).pop(true); // Return true when sign out button is pressed
          },
        ),
      ],
    );
  }
}

// to leave user logged in
void _toLoginPage(BuildContext context) async{
  //Unset the 'username' filed in SharedPreference
  final sp = await SharedPreferences.getInstance();
  sp.remove('logged');
  //Pop the drawer first
  Navigator.pop(context);
  //Then pop the HomePage
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
}//_toCalendarPage