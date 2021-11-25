import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/constants/constants.dart';
import 'package:shopapp/models/httpException.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userID {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    try {
      final response = await http.post(Uri.parse(firebaseSignUpAuthUri),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final extractedResponse = json.decode(response.body);
      print(extractedResponse);
      if (extractedResponse['error'] != null) {
        throw HttpException(extractedResponse['error']['message']);
      }
      _token = extractedResponse['idToken'];
      _userId = extractedResponse['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(extractedResponse['expiresIn'])));
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userID': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userInfo', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await http.post(Uri.parse(firebaseSignInAuthUri),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final extractedResponse = json.decode(response.body);
      print(extractedResponse);
      if (extractedResponse['error'] != null) {
        throw HttpException(extractedResponse['error']['message']);
      }
      _token = extractedResponse['idToken'];
      _userId = extractedResponse['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(extractedResponse['expiresIn'])));
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userID': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userInfo', userData);
      //return extractedResponse;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    return true;
    // final prefs = await SharedPreferences.getInstance();

    // if (!prefs.containsKey('userInfo')) {
    //   return false;
    // }

    // final extractedUserData =
    //     json.decode(prefs.getString('userInfo')) as Map<String, Object>;

    // final expiryDate = DateTime.parse(extractedUserData['expiryData']);

    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }

    // _token = extractedUserData['token'];
    // _expiryDate = expiryDate;
    // _userId = extractedUserData['userID'];
    // notifyListeners();
    // autoLogOut();
    // return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }
}
