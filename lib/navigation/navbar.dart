import 'package:fitfacts/database/DatabaseRepo.dart';
import 'package:fitfacts/server/NetworkUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fitfacts/themes/theme.dart';
import 'package:fitfacts/screens/loginPage.dart';
import '../database/DataDownloader.dart';
import '../screens/impactLogin.dart';

// DRAWER DATE FORMATTER
DateTime _drawerDate = DateTime.now().subtract(const Duration(days: 1));

/// NAVBAR MAIN WIDGET
/// Returns a Drawer to display
///
/// Header: [NavHeader]
/// Fitbit Server Status: [ServerStatus]
/// Activity List: [NavList]
/// Toolbar: [BottomBar]
///
class Navbar extends StatefulWidget {


  const Navbar(
      {Key? key})
      : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect( // Border Radius of Drawer
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: Drawer(
        backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      const NavHeader(),
                      const ServerStatus(),
                      NavList(primaryColor: Theme.of(context).primaryColor)
                    ],
                  ),
                ],
              ),
            ),
            const BottomBar(),
          ],
        ),
      ),
    );
  }
}

/// NAVIGATION HEADER WIDGET
///
class NavHeader extends StatefulWidget {


  const NavHeader(
      {Key? key})
      : super(key: key);

  @override
  State<NavHeader> createState() => _NavHeaderState();
}

class _NavHeaderState extends State<NavHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.fromLTRB(20.0, 80, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, d MMMM').format(_drawerDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Hello, ",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Consumer<DatabaseRepository>(
                      builder: (context, dbr, child){
                        return FutureBuilder(
                            initialData: '--',
                            future: Provider.of<DatabaseRepository>(context).getUsername(),
                            builder: (context, snapshot){
                              if (snapshot.hasData){
                                final data = snapshot.data as String;
                                return Text(
                                  data,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                );
                              } else {
                                return Text(
                                  '--',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                );
                              }
                            }
                        );
                      },
                    )
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.purple[50],
                  radius: 25,
                  foregroundImage: Image.asset('assets/images/profilePic.png').image,
                )
              ],
            ),
          ],
        ));
  }
}

/// FITBIT STATUS WIDGET
///
class ServerStatus extends StatefulWidget {

  const ServerStatus(
      {Key? key})
      : super(key: key);

  @override
  State<ServerStatus> createState() => _ServerStatusState();
}

class _ServerStatusState extends State<ServerStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).primaryColor.withAlpha(30)
          ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.stars_rounded,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              Container(
                width: 25,
              ),
              Consumer<DatabaseRepository>(
                  builder: (context, dbr, child){
                    return FutureBuilder(
                        initialData: '--',
                        future: Provider.of<DatabaseRepository>(context).getSmartStars(),
                        builder: (context, snapshot){
                          if (snapshot.hasData){
                            return  Text('${snapshot.data}', style: const TextStyle( fontSize: 24,fontWeight:  FontWeight.w700),);
                          } else {
                            return  const Text('--', style: TextStyle( fontSize: 24,fontWeight:  FontWeight.w700),);
                          }
                        });
                  }),
              Container(width: 5,),
              const Text( /// TO CHANGE AT A LATER TIME
                'Smart Stars',
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ],
      ),
    );
  }
}

/// NAVIGATION LIST
///
dynamic _selection = '/home'; // Detects current page

class NavList extends StatefulWidget {
  final Color primaryColor;

  const NavList({Key? key, required this.primaryColor}) : super(key: key);

  @override
  State<NavList> createState() => _NavListState();
}

class _NavListState extends State<NavList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 40, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('YOUR ACTIVITY'),
          Container(
            height: 10,
          ),
          Column(
            children: [
              /// ADD NAVIGATION LINKS HERE
              NavItem(
                  icon: Icons.home_rounded,
                  title: 'Dashboard',
                  destinationView: '/home',
                  color: widget.primaryColor),
              NavItem(
                  icon: Icons.favorite_rounded,
                  title: 'Heart',
                  destinationView: '/heart',
                  color: widget.primaryColor),
              NavItem(
                  icon: Icons.dark_mode_rounded,
                  title: 'Sleep',
                  destinationView: '/sleep',
                  color: widget.primaryColor),
              NavItem(
                  icon: Icons.local_fire_department_rounded,
                  title: 'Calories',
                  destinationView: '/calories',
                  color: widget.primaryColor),
              NavItem(
                  icon: Icons.directions_walk,
                  title: 'Steps',
                  destinationView: '/steps',
                  color: widget.primaryColor),
              NavItem(
                  icon: Icons.sports,
                  title: 'Activity',
                  destinationView: '/activity',
                  color: widget.primaryColor),
            ],
          ),
          Container(height: 30,),
          const Text('SETTINGS'),
          Container(
            height: 10,
          ),
          Column(
            children: [
              NavItem(
                  icon: Icons.account_circle,
                  title: 'Profile',
                  destinationView: '/profile',
                  color: widget.primaryColor),
            ],
          )
        ],
      ),
    );
  }
}

/// NAVIGATION LINK ITEM
///
class NavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String destinationView;
  final Color color;

  const NavItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.destinationView,
      required this.color})
      : super(key: key);

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context.watch<ThemeModel>().mode;
    var greyColor = (themeMode == ThemeMode.light) ? Colors.grey[700] : Colors.grey[300];

    return Theme(
      data: ThemeData(
          splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: InkWell(
        onTap: () async {
          if (_selection == widget.destinationView) {
           Navigator.of(context).pop();
          } else {
            Navigator.pushNamedAndRemoveUntil(context, widget.destinationView,
                    ModalRoute.withName(widget.destinationView));
            _selection = widget.destinationView;
          }
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: (_selection == widget.destinationView)
                  ? widget.color.withAlpha(25)
                  : Colors.grey.withAlpha(30)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 25,
                color: (_selection == widget.destinationView)
                    ? widget.color
                    : greyColor,
              ),
              Container(
                width: 20,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: (_selection == widget.destinationView)
                      ? widget.color
                      : greyColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_right,
                color: (_selection == widget.destinationView)
                    ? widget.color
                    : greyColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// BOTTOM TOOLBAR WIDGET
///
class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context.watch<ThemeModel>().mode;

    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 0, 20),
        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// THEME SELECTOR
                  IconButton(
                      onPressed: () {
                        context.read<ThemeModel>().toggleMode();
                      },
                      icon: (themeMode == ThemeMode.dark) ? const Icon(Icons.light_mode_rounded) : const Icon(Icons.dark_mode_rounded))
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// REFRESH ACTION HERE
                    IconButton(
                        onPressed: () async {
                          try {
                            print('TOKEN: ${await TokenManager.accessToken(
                                context)}');
                            await downloadAndStoreData(context);
                          }catch(error){ // can't refresh
                            print(error);
                            final tokenResult = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ImpactLogin();
                            }),
                            );
                            if (tokenResult == 200){
                              print('TOKENS RENEWED');
                              await downloadAndStoreData(context);
                            }else {
                              print('ERROR WHILE RENEWING TOKENS');
                            }
                          }finally{
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor: Theme.of(context).primaryColor,
                              content: const Center(child: Text('Fitbit Data Refreshed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)),
                            ));
                          }
                        },
                        icon: const Icon(Icons.refresh))
                  ],
                )),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// LOGOUT ACTION HERE
                    IconButton(
                        onPressed: () async{
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SignOutAlertDialog();
                            },
                          ).then((value) async {
                            if (value != null && value == true) {
                              await Provider.of<DatabaseRepository>(context, listen: false).wipeDatabase();
                              clearSharedPreferences();
                              _toLoginPage(context);
                            } else {
                              // User canceled sign out
                            }
                          });
                          }, icon: const Icon(Icons.logout))
                  ],
                ))
          ],
        ));
  }
}

// to leave user logged in
void _toLoginPage(BuildContext context) async{
  //Pop the drawer first
  Navigator.pop(context);
  //Then pop the HomePage
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
}//_toCalendarPage


/// SignOutVerification
///
class SignOutAlertDialog extends StatelessWidget {

  const SignOutAlertDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure?\nYou will be disconnected from your Fitbit\nAll data linked to you will be erased',
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