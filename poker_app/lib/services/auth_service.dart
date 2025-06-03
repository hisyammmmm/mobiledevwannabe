import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoggedIn = false;
  String _username = '';
  final Map<String, String> _userDatabase = {};

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;

  Future<void> register(String username, String password) async {
    final SharedPreferences prefs = await _prefs;

    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username dan password harus diisi');
    }

    if (_userDatabase.containsKey(username)) {
      throw Exception('Username sudah terdaftar');
    }

    _userDatabase[username] = password; // Simpan di memory
    await prefs.setString('users', jsonEncode(_userDatabase)); // Simpan ke SharedPreferences
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    final SharedPreferences prefs = await _prefs;

    // Load user database dari SharedPreferences
    final usersJson = prefs.getString('users') ?? '{}';
    final users = Map<String, String>.from(jsonDecode(usersJson));

    if (users[username] != password) {
      throw Exception('Username atau password salah');
    }

    _isLoggedIn = true;
    _username = username;
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
    notifyListeners();
  }

  Future<void> autoLogin() async {
    final SharedPreferences prefs = await _prefs;
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _username = prefs.getString('username') ?? '';
    notifyListeners();
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    _isLoggedIn = false;
    _username = '';
    await prefs.remove('isLoggedIn');
    notifyListeners();
  }
}