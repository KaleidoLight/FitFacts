import 'package:fitfacts/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class SmallBlock extends StatefulWidget {

  String title;
  IconData  icon;
  String date;
  Widget body;

  SmallBlock({Key? key, required this.title, required this.icon, this.date = '', required this.body}) : super(key: key);

  @override
  State<SmallBlock> createState() => _SmallBlockState();
}

class _SmallBlockState extends State<SmallBlock> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    var bkColor = (themeMode == ThemeMode.light) ? Colors.white.withAlpha(200) :
    Colors.white.withAlpha(40);

    return Column(
      children: [
        SizedBox(
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

//ignore: must_be_immutable
class LargeBlock extends StatefulWidget {

  String title;
  IconData  icon;
  String date;
  Widget body;
  int extraHeight;
  dynamic data;
  bool showBk;

  LargeBlock({Key? key, required this.title, required this.icon, this.date = '', required this.body, this.data, this.extraHeight = 0, this.showBk = true}) : super(key: key);

  @override
  State<LargeBlock> createState() => _LargeBlockState();
}

class _LargeBlockState extends State<LargeBlock> {
  @override
  Widget build(BuildContext context) {

    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    var bkColor = (widget.showBk) ? (themeMode == ThemeMode.light) ? Colors.white.withAlpha(200) :
    Colors.white.withAlpha(40) : (themeMode == ThemeMode.light) ? Colors.white.withAlpha(200) :
    Colors.transparent;

    return Column(
      children: [
        SizedBox(
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
                              Text(widget.date, style: const TextStyle(fontWeight: FontWeight.w600),),
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
