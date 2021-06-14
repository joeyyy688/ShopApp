import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/constants/constants.dart';
import 'package:shopapp/models/httpException.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
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
      //return extractedResponse;
      notifyListeners();
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
      notifyListeners();
      //return extractedResponse;
    } catch (e) {
      throw e;
    }
  }
}
