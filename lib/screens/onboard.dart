import 'package:fitfacts/database/DataDownloader.dart';
import 'package:fitfacts/server/Impact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:fitfacts/screens/profilePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fitfacts/database/DatabaseRepo.dart';
import '../database/UserInfo.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  static const routename = 'Onboard';

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    print('${Onboard.routename} built'); // REMOVE BEFORE PRODUCTION

    final username = GlobalKey<FormBuilderState>();
    final password = GlobalKey<FormBuilderState>();

    return Scaffold(
        body: IntroductionScreen(
      showNextButton: _currentPageIndex != 0,
      showBackButton: _currentPageIndex != 3,
      showSkipButton: false,
      showDoneButton: false,
      next: const Text(
        'Next',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      back: const Text(
        'Back',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      freeze: true,
      key: _introKey,
      onChange: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      onDone: () {},
      onSkip: () {},
      pages: [
        PageViewModel(
          // FITBIT LOGIN
          title: "Link your Fitbit",
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          useScrollView: true,
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Welcome to FitFacts! \n We hope you will learn a lot from your fitness data. '
                'To start, link your fitbit profile',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilder(
                    key: username,
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      username.currentState!.save();
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: FormBuilderTextField(
                        name: 'Username',
                        decoration: const InputDecoration(
                            labelText: 'Username',
                            focusedBorder: InputBorder.none),
                      ),
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilder(
                          key: password,
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: () {
                            password.currentState!.save();
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: FormBuilderTextField(
                              name: 'Password',
                              decoration: const InputDecoration(
                                  labelText: 'Password',
                                  focusedBorder: InputBorder.none),
                              obscureText: true,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(
                            Icons.login_rounded,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () async {
                            String user =
                                username.currentState?.value['Username'] ?? '';
                            String pass =
                                password.currentState?.value['Password'] ?? '';
                            print('$user .. $pass');
                            int response =
                                await Impact().authorize(context, user, pass);
                            if (response == 200) {
                              print('AUTHORIZED');
                              Provider.of<DatabaseRepository>(context,
                                      listen: false)
                                  .registerUser(UserInfo('User', '00-00-0000',
                                      'Male', 0, 0, 0, 0, 0));
                              _introKey.currentState?.next();
                            }
                          }))
                ],
              )
            ],
          ),
          image: Center(
              child: Column(
            children: [
              Container(
                height: 60,
              ),
              Image.asset(
                'assets/images/fitbitLink.png',
                scale: 1,
              ),
            ],
          )),
        ),
        PageViewModel(
          // PAGE 2
          image: Center(
              child: Column(
            children: [
              Container(
                height: 60,
              ),
              Image.asset(
                'assets/images/personalInfo.png',
                scale: 1,
              ),
            ],
          )),
          title: "About You",
          decoration: const PageDecoration(
            bodyFlex: 1,
            imagePadding: EdgeInsets.only(bottom: 0),
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          bodyWidget: Column(
            children: const [
              Text(
                'It will let us better understand your activity',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              DefaultInfoItem(
                badgeIcon: Icons.person_rounded,
                title: 'Username',
                validator: Validators.required,
                queryString: 'Username',
              ),
              GenderSelectorStyled(
                  badgeIcon: Icons.transgender, title: 'Gender'),
              DateInfoItem(),
            ],
          ),
        ),
        PageViewModel(
            image: Center(
                child: Column(
              children: [
                Container(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/personalGoal.png',
                  scale: 1,
                ),
              ],
            )),
            title: "Your Goals and Metrics",
            decoration: const PageDecoration(
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            bodyWidget: Column(
              children: const [
                Text(
                  'Tell us a bit more...',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                DefaultInfoItem(
                  badgeIcon: Icons.height_rounded,
                  title: 'Height',
                  unit: '(cm)',
                  queryString: 'Height',
                ),
                DefaultInfoItem(
                  badgeIcon: Icons.monitor_weight_outlined,
                  title: 'Weight',
                  unit: '(kg)',
                  queryString: 'Weight',
                ),
                DefaultInfoItem(
                  badgeIcon: Icons.local_fire_department_rounded,
                  title: 'Calories Goal',
                  unit: '(kCal)',
                  queryString: 'CalorieGoal',
                ),
                DefaultInfoItem(
                  badgeIcon: Icons.directions_walk_rounded,
                  title: 'Steps Goal',
                  queryString: 'StepGoal',
                ),
              ],
            )),
        PageViewModel(
            image: Center(
                child: Column(
              children: [
                Container(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/loading.png',
                  scale: 1,
                ),
              ],
            )),
            title: "Setting up your Dashboard",
            decoration: const PageDecoration(
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            bodyWidget: VisibilityDetector(
              key: const Key('your_widget_key'),
              onVisibilityChanged: (visibilityInfo) async {
                if (visibilityInfo.visibleFraction == 1.0) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('hasOnboarded', true);
                  performLoginSetup(context);
                }
              },
              child: Column(
                children: [
                  const Text(
                    'This might take a while. \n Do not disconnect your device from the Internet',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 20,
                  ),
                  CircularProgressIndicator(
                      strokeWidth: 6, color: Theme.of(context).primaryColor)
                ],
              ),
            ))
      ],
    ));
  }
}

void performLoginSetup(BuildContext context) async {
  await downloadAndStoreData(context);

  //Perform Redirection to App
  await Future.delayed(const Duration(seconds: 2));
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/home',
    (route) => false,
  );
}
