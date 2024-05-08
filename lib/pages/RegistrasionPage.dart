import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Tambahkan ini untuk menyembunyikan banner debug
      theme: ThemeData(
          // Tambahkan tema aplikasi jika diperlukan
          ),
      home: Scaffold(
        body: Text('Muhammad Haykal'),
      ),
    );
  }
}
