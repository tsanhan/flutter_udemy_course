import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  static const _webAPIKey = "AIzaSyAG8PhWkYgQa9jve_HUHLvb9ds11oYrw14";
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String route) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$route?key=$_webAPIKey';
    try {
      var response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final resData = json.decode(response.body);

      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }

      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      _autoLogout();
      notifyListeners();

      // save consistent data
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutologin() async {
      final prefs = await SharedPreferences.getInstance();
      if(!prefs.containsKey('userData'))
        return false;
      
      final extractedUserData = json.decode(prefs.getString('userData')) as Map<String,Object>;
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      if(expiryDate.isBefore(DateTime.now()))
        return false;
      
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _expiryDate = expiryDate;

      notifyListeners();
      _autoLogout();

      return true;

  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = _userId = _expiryDate = null;
    _authTimer.cancel();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();

    final timeToExpiery = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiery), () => logout());
  }
}
