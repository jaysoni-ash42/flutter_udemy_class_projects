import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/custom_exception.dart';
import 'dart:convert';
import 'package:shop_app/util/constants.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _userId = "";
  String _token = "";
  DateTime _expiresIn = DateTime.now();

  bool get isAuth {
    return _token != "" ? true : false;
  }

  String get token {
    if (_expiresIn.isAfter(DateTime.now()) && _token != "" && _userId != "") {
      return _token;
    }
    return "";
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String newUrl) async {
    var url = Uri(
        scheme: 'https',
        host: dotenv.env[FIRE_BASE_AUTH_API_URL],
        path: '/v1/accounts:$newUrl',
        queryParameters: {"key": dotenv.env[FIRE_BASE_WEB_API_KEY]});
    try {
      var response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _token = responseData["idToken"];
        _expiresIn = DateTime.now()
            .add(Duration(seconds: int.parse(responseData["expiresIn"])));
        _userId = responseData["localId"];
        autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          "userId": _userId,
          "token": _token,
          "expiresIn": _expiresIn.toIso8601String()
        });
        prefs.setString("userData", userData);
      } else {
        throw CustomException(
            message: json.decode(response.body)["error"]["message"]);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  void logOut() async {
    _token = "";
    _userId = "";
    _expiresIn = DateTime.now();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    final timeToExpire = _expiresIn.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpire), () => {logOut()});
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final userData = json.decode(prefs.getString("userData").toString())
        as Map<String, Object>;
    final expiryDate = DateTime.parse(userData["expiresIn"].toString());
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData["token"].toString();
    _userId = userData["userId"].toString();
    _expiresIn = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }
}
