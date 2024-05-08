import 'package:flutter/material.dart';
import 'package:starlibrary/layouts/Navbar.dart';
import 'package:starlibrary/pages/HomePage.dart';
import 'package:starlibrary/pages/welcome.dart';
import 'package:starlibrary/pages/SplasScreen.dart';
import 'package:starlibrary/pages/profile.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tambahkan ini untuk menyembunyikan banner debug
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      home: Welcome(),
    );
  }
}
