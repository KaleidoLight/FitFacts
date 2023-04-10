import 'package:flutter/material.dart';

// DRAWER DATE FORMATTER
DateTime _drawerDate = DateTime.now();

/// NAVBAR MAIN WIDGET
/// Returns a Drawer to display
/// Header: [NavHeader]
/// Fitbit Server Status: [ServerStatus]
/// Activity List: [NavList]
/// Toolbar: [BottomBar]
///
class Navbar extends StatefulWidget {

  final String username; // The username to display
  final Color primaryColor; // The color accent of the widget

  const Navbar(
      {Key? key, required this.username, this.primaryColor = Colors.teal})
      : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      NavHeader(
                        username: widget.username,
                        primaryColor: widget.primaryColor,
                      ),
                      ServerStatus(
                        primaryColor: widget.primaryColor,
                      ),
                      NavList(primaryColor: widget.primaryColor)
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
  final String username;
  final Color primaryColor;

  const NavHeader(
      {Key? key, required this.username, required this.primaryColor})
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
              "${_drawerDate.day.toString()}-${_drawerDate.month
                  .toString()}-${_drawerDate.year.toString()}",
              style: const TextStyle(fontSize: 15),
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
                    Text(
                      widget.username,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: widget.primaryColor),
                    ),
                  ],
                ),
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(
                    '--', // Change with profile picture later
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

/// FITBIT STATUS WIDGET
///
class ServerStatus extends StatefulWidget {
  final Color primaryColor;

  const ServerStatus({Key? key, required this.primaryColor}) : super(key: key);

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
          color: widget.primaryColor.withAlpha(20)),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            Icon(
              Icons.fitbit,
              color: widget.primaryColor,
            ),
            Container(width: 20,),
            const Text(
              'FITBIT OF ALBERTO',
              style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            )
          ],),
        ],
      ),
    );
  }
}

/// NAVIGATION LIST
///
dynamic _selection = '/'; // Detects current page
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
            children: [ /// ADD NAVIGATION LINKS HERE
              NavItem(icon: Icons.home_rounded, title: 'Overview', destinationView: '/', color: widget.primaryColor),
            ],
          ),
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
      {Key? key, required this.icon, required this.title, required this.destinationView, required this.color})
      : super(key: key);

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: InkWell(
        onTap: () async {
          Navigator.pushNamedAndRemoveUntil(context, widget.destinationView, ModalRoute.withName(widget.destinationView)).then((value) => Navigator.popUntil(context, ModalRoute.withName(widget.destinationView)));
          _selection = widget.destinationView;
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: (_selection == widget.destinationView) ? widget.color.withAlpha(25) : Colors.grey.withAlpha(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 25,
                    color: (_selection == widget.destinationView) ? widget.color : Colors.black87,
                  ),
                  Container(
                    width: 20,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: (_selection == widget.destinationView) ? widget.color : Colors.black87,
                    ),

                  ),
                  const Spacer(),
                  Icon(Icons.arrow_right, color: (_selection == widget.destinationView) ? widget.color : Colors.black87,)
                ],
              ),
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
                children: [ /// RELOAD DATA ACTION HERE
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.refresh_outlined))
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ /// SETTING ACTION HERE
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.settings_outlined))
                  ],
                )
            ),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ /// LOGOUT ACTION HERE
                    IconButton(onPressed: () {}, icon: Icon(Icons.exit_to_app))
                  ],
                )
            )
          ],
        )
    );
  }
}
