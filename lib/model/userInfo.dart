import 'package:flutter/material.dart';

class UserInfo extends ChangeNotifier{

  Map<String, String> _map = {'gender':'default', 
                              'bornDate':'default',
                              'age':'default',
                              'weight':'default',
                              'calGoal':'default',
                              'steps':'default'};

  Map get Info => _map;
  
  void updateInfo(String key, var value){
    _map[key] = value;
    notifyListeners();
  }

  String? getInfo(String key){
    return _map[key];
  }

  void resetInfo(){
    _map = {'gender':'default', 
            'bornDate':'default',
            'age':'default',
            'weight':'default',
            'calGoal':'default',
            'steps':'default'};
    notifyListeners();
  }

}