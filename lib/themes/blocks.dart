import 'package:fitfacts/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class smallBlock extends StatefulWidget {

  String title;
  IconData  icon;
  String date;
  Widget body;

  smallBlock({Key? key, required this.title, required this.icon, this.date = '', required this.body}) : super(key: key);

  @override
  State<smallBlock> createState() => _smallBlockState();
}

class _smallBlockState extends State<smallBlock> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.white.withAlpha(200) :
    Colors.white.withAlpha(40);

    return Column(
      children: [
        Container(
          width:  MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.width/2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: bkColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(widget.icon, color: Theme.of(context).primaryColor,),
                              Container(width: 8,),
                              Text(widget.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),),
                            ],
                          ),
                          Row(
                            children: [
                              Text(widget.date),
                              Container(width: 5,),
                            ],
                          )
                        ],
                      ),
                      Container(height: 5,),
                      Expanded(child: widget.body)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class largeBlock extends StatefulWidget {

  String title;
  IconData  icon;
  String date;
  Widget body;
  int extraHeight;
  dynamic data;

  largeBlock({Key? key, required this.title, required this.icon, this.date = '', required this.body, this.data, this.extraHeight = 0}) : super(key: key);

  @override
  State<largeBlock> createState() => _largeBlockState();
}

class _largeBlockState extends State<largeBlock> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.white.withAlpha(200) :
    Colors.white.withAlpha(40);

    return Column(
      children: [
        Container(
          width:  MediaQuery.of(context).size.width/1,
          height: MediaQuery.of(context).size.width/2 + widget.extraHeight,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: bkColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(widget.icon, color: Theme.of(context).primaryColor,),
                              Container(width: 8,),
                              Text(widget.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),),
                            ],
                          ),
                          Row(
                            children: [
                              Text(widget.date),
                              Container(width: 5,),
                            ],
                          )
                        ],
                      ),
                      Container(height: 5,),
                      Expanded(child: widget.body)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
