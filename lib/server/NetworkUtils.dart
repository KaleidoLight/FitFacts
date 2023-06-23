import 'package:fitfacts/screens/impactLogin.dart';
import 'package:fitfacts/server/Encrypter.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:fitfacts/server/Impact.dart';


/// NetworkUtils
///
///
class NetworkUtils {
  static Future<bool> hasInternetConnection() async { // Check if device is connected to internet (ext. dependency)
    return await InternetConnectionChecker().hasConnection;
  }
}

// NETWORKING EXCEPTIONS

///NoInternetConnectionException
///
class NoInternetConnectionException implements Exception {
  final String message;

  NoInternetConnectionException(this.message);

  @override
  String toString() => message;
}

///ServerUnreachableException
///
class ServerUnreachableException implements Exception {
  final String message;

  ServerUnreachableException(this.message);

  @override
  String toString() => message;
}

///AuthorizationException
///
class AuthorizationException implements Exception {
  final String message;

  AuthorizationException(this.message);

  @override
  String toString() => message;
}

/// TokenManager
///
/// The managing class for API Tokens
class TokenManager {

  static Future<void> storeTokens(Map<String, dynamic> tokens) async {
    final sp = await SharedPreferences.getInstance();
    String secretKey = sp.getString('firstLoginTime') ?? 'secret_key_missing';
    String encryptedAccess = encryptToken(tokens['access'], secretKey); // encrypt token
    String encryptedRefresh = encryptToken(tokens['refresh'], secretKey); //encrypt token
    await sp.setString('access', encryptedAccess); // save
    await sp.setString('refresh', encryptedRefresh); // save
  }

  /// refreshToken
  ///
  /// Returns the current refreshToken
  static Future<String?> refreshToken(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    String secretKey = sp.getString('firstLoginTime') ?? 'secret_key_missing';
    var token = decryptToken(sp.getString('refresh')!, secretKey);
    if (JwtDecoder.isExpired(token)){
      print('REFRESH TOKEN EXPIRED');
      final tokenResult = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ImpactLogin();
        }),
      );
      if (tokenResult == 200){
        print('TOKENS RENEWED');
      }else {
        print('ERROR WHILE RENEWING TOKENS');
      }
    }
    return token;
  }

  /// accessToken
  ///
  /// Returns the current access token
  /// If expired automatically requests a new one
  static Future<String?> accessToken(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    String secretKey = sp.getString('firstLoginTime') ?? 'secret_key_missing';
    var token = decryptToken(sp.getString('access')!, secretKey);
    if (JwtDecoder.isExpired(token)){
      await Impact().updateTokens(context);
      token = decryptToken(sp.getString('access')!, secretKey);
      print('ACCESS TOKEN RENEWED');
    }
    return token;
  }
}

// Clear SharedPreferences
Future<void> clearSharedPreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}