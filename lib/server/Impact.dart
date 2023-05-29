/// IMPACT API REFERENCE CLASS
///

import 'dart:io';
import 'package:fitfacts/Models/Calories.dart';
import 'package:fitfacts/Models/Sleep.dart';
import 'package:fitfacts/Models/Steps.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitfacts/server/NetworkUtils.dart';
import 'package:intl/intl.dart';

import '../Models/Activity.dart';
import '../Models/HeartRate.dart';

class Impact{

  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static String username = 'MMmxITaSML';
  static String password = '12345678!';

  // DATA
  static String patientUsername    = 'Jpefaq6m58';

  static String stepsEndpoint      = 'data/v1/steps/patients/';
  static String calorieEndpoint    = 'data/v1/calories/patients/';
  static String heartEndpoint      = 'data/v1/heart_rate/patients/';
  static String sleepEndpoint      = 'data/v1/sleep/patients/';
  static String activityEndpoint   = 'data/v1/exercise/patients/';
  
  //This method allows to check if the IMPACT backend is up
  Future<bool> _isServerUp() async {

    //Create the request
    final url = Impact.baseUrl + Impact.pingEndpoint;

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url));

    //Just return if the status code is OK
    return response.statusCode == 200;
  } //_isImpactUp

  // Connect to Server
  Future connect() async {
    bool hasConnection = await NetworkUtils.hasInternetConnection();
    if (!hasConnection) {throw NoInternetConnectionException('No Internet Connection');}
    bool isServerUp = await _isServerUp();
    if (!isServerUp) {throw ServerUnreachableException('Server is unreachable, try again in few minutes');}
    return true;
  }

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> authorize(BuildContext context, String username, String password) async {
    try {
      await connect(); // Can we connect to server?

      final url = Impact.baseUrl + Impact.tokenEndpoint;
      final body = {'username': username, 'password': password};

      print('Calling: $url');
      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        print(decodedResponse);
        await TokenManager.storeTokens(decodedResponse);
      } else {
        throw AuthorizationException('Authorization failed: Credentials Incorrect');
      }
      return response.statusCode;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
    return 400;
  }

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> updateTokens() async {

    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final body = {'refresh': await TokenManager.refreshToken()};

    //Get the response
    print('Calling: $url');
    try{
      await connect();
      final response = await http.post(Uri.parse(url), body: body);

      //If 200 set the tokens
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        print(decodedResponse);
        await TokenManager.storeTokens(decodedResponse);
      } else {
        throw AuthorizationException('Authorization failed: Refresh Token Error');
      }
      //Return just the status code
      return response.statusCode;
    } catch (error) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
    return 400;

  } //_refreshTokens

  Future<Calories> getCalories() async {

    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
    String fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 8)));

    final url = '${Impact.baseUrl}${Impact.calorieEndpoint}${Impact.patientUsername}/daterange/start_date/$fromDate/end_date/$endDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer ${await TokenManager.accessToken()}'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return Calories.fromJson(decodedResponse);
    } //if
    else{
      throw Exception('Failed to load data');
    }//else

  }

  Future<Steps> getSteps() async {

    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
    String fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 8)));

    final url = '${Impact.baseUrl}${Impact.stepsEndpoint}${Impact.patientUsername}/daterange/start_date/$fromDate/end_date/$endDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer ${await TokenManager.accessToken()}'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return Steps.fromJson(decodedResponse);
    } //if
    else{
      throw Exception('Failed to load data');
    }//else

  }

  Future<HeartRate> getHeartRate() async {

    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
    String fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 8)));

    final url = '${Impact.baseUrl}${Impact.heartEndpoint}${Impact.patientUsername}/daterange/start_date/$fromDate/end_date/$endDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer ${await TokenManager.accessToken()}'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return HeartRate.fromJson(decodedResponse);
    } //if
    else{
      throw Exception('Failed to load data');
    }//else

  }

  Future<Sleep> getSleep() async {

    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
    String fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 8)));

    final url = '${Impact.baseUrl}${Impact.sleepEndpoint}${Impact.patientUsername}/daterange/start_date/$fromDate/end_date/$endDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer ${await TokenManager.accessToken()}'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return Sleep.fromJson(decodedResponse);
    } //if
    else{
      throw Exception('Failed to load data');
    }//else

  }

  Future<Activity> getActivity() async {

    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
    String fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 8)));

    final url = '${Impact.baseUrl}${Impact.activityEndpoint}${Impact.patientUsername}/daterange/start_date/$fromDate/end_date/$endDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer ${await TokenManager.accessToken()}'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return Activity.fromJson(decodedResponse);
    } //if
    else{
      throw Exception('Failed to load data');
    }//else

  }

}//Impact



