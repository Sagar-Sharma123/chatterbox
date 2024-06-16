import 'package:chatterbox/screen/mainScreen.dart';
import 'package:chatterbox/screen/signScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();
  var username = pref.getString('username');

  runApp(MaterialApp(
    home: username == null ? const SignPage() : MainScreen(username),
  ));
}
