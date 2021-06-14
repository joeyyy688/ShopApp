import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/constants/constants.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

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
      return extractedResponse;
    } catch (e) {}
  }

  Future<void> signIn(String email, String password) async {
    final response = await http.post(Uri.parse(firebaseSignInAuthUri),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    final extractedResponse = json.decode(response.body);
    print(extractedResponse);
    return extractedResponse;
  }
}
