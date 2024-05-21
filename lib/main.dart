import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlibrary/pages/HomePage.dart';
import 'package:starlibrary/pages/LoginPage.dart';
import 'package:starlibrary/pages/welcome.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.storage.request();
  // Menunda hide splash screen selama 1 detik
  await Future.delayed(Duration(seconds: 1));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');

  runApp(MainApp(
    email: email,
    password: password,
  ));
}

class MainApp extends StatelessWidget {
  final String? email;
  final String? password;

  const MainApp({Key? key, this.email, this.password}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        useMaterial3: true,
      ),
      home: email != null && password != null
          ? LoginPage() // Navigasi langsung ke HomePage jika email dan password tersedia
          : Welcome(),
    );
  }
}
