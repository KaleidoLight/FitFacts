import 'package:fitfacts/server/Impact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:introduction_screen/introduction_screen.dart';

class ImpactLogin extends StatelessWidget {
  ImpactLogin({Key? key}) : super(key: key);

  static const routename = 'ImpactLogin';
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    print('${ImpactLogin.routename} built'); // REMOVE BEFORE PRODUCTION

    final username = GlobalKey<FormBuilderState>();
    final password = GlobalKey<FormBuilderState>();

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
                    'Link your Fitbit! \n Your connection to the fitbit is expired\nLog In Again',
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
                                  decoration:
                                  const InputDecoration(labelText: 'Password', focusedBorder: InputBorder.none),
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
                                  // REFRESH TOKEN
                                  Navigator.pop(context, response);
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
          ],
        ));
  } //build
}






