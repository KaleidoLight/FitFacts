import 'package:fitfacts/server/Impact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:fitfacts/screens/profilePage.dart';

class Onboard extends StatelessWidget {
  Onboard({Key? key}) : super(key: key);

  static const routename = 'Onboard';
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    print('${Onboard.routename} built'); // REMOVE BEFORE PRODUCTION

    final _username = GlobalKey<FormBuilderState>();
    final _password = GlobalKey<FormBuilderState>();

    return Scaffold(
        body: IntroductionScreen(
          showNextButton: false,
          showBackButton: false,
          showSkipButton: false,
          showDoneButton: false,
          freeze: true,
          key: _introKey,
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
                    key: _username,
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      _username.currentState!.save();
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: FormBuilderTextField(
                        name: 'Username',
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        //initialValue: 'MMmxITaSML',
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
                          key: _password,
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: () {
                            _password.currentState!.save();
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: FormBuilderTextField(
                              name: 'Password',
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              //initialValue: '12345678!',
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
                                _username.currentState?.value['Username'] ?? '';
                            String pass =
                                _password.currentState?.value['Password'] ?? '';
                            print('$user .. $pass');
                            int response =
                                await Impact().authorize(context, user, pass);
                            if (response == 200) {
                              print('AUTHORIZED');
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
                'assets/images/fitbit_login_hero.png',
                scale: 1,
                height: 300,
                width: 300,
              ),
            ],
          )),
        ),

        PageViewModel(
            image: Center(
                child: Column(
              children: [
                Container(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/fitbit_login_data.png',
                  scale: 1,
                  height: 300,
                  width: 300,
                ),
              ],
            )),
            title: "About You",
            decoration: const PageDecoration(
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            bodyWidget: Column(
              children: [
                const Text(
                  'It will let us better understand your activity',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                DefaultInfoItem(
                  badgeIcon: Icons.person_rounded,
                  title: 'Username',
                  validator: Validators.required,
                ),
                GenderSelectorStyled(
                    badgeIcon: Icons.transgender, title: 'Gender'),
                DateInfoItem(),
                proceedButton(route: _introKey)
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
                  'assets/images/fitbit_login_data2.png',
                  scale: 1,
                  height: 300,
                  width: 300,
                ),
              ],
            )),
            title: "Your Goals and Metrics",
            decoration: const PageDecoration(
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            bodyWidget: Column(
              children: [
                const Text(
                  'Tell us a bit more...',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const DefaultInfoItem(
                  badgeIcon: Icons.height_rounded,
                  title: 'Height',
                  unit: '(cm)',
                ),
                const DefaultInfoItem(
                  badgeIcon: Icons.monitor_weight_outlined,
                  title: 'Weight',
                  unit: '(kg)',
                ),
                const DefaultInfoItem(
                  badgeIcon: Icons.local_fire_department_rounded,
                  title: 'Calories Goal',
                  unit: '(kCal)',
                ),
                const DefaultInfoItem(
                  badgeIcon: Icons.directions_walk_rounded,
                  title: 'Steps Goal',
                ),
                proceedButton(route: _introKey)
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
                  'assets/images/fitbit_login_hero.png',
                  scale: 1,
                  height: 300,
                  width: 300,
                ),
              ],
            )),
            title: "Setting up your Dashboard",
            decoration: const PageDecoration(
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            bodyWidget: Column(
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
            ))
      ],
    ));
  } //build
}

class proceedButton extends StatefulWidget {
  proceedButton({Key? key, required this.route, this.title = 'Next'})
      : super(key: key);

  final String title;
  final GlobalKey<IntroductionScreenState> route;
  @override
  State<proceedButton> createState() => _proceedButtonState();
}

class _proceedButtonState extends State<proceedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          child: Container(
            height: 60,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ),
          onTap: () {
            widget.route.currentState?.next();
            print('pressed');
          },
        ),
      ),
    );
  }
}
