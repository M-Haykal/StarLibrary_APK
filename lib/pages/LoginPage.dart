import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void iniState() {
    _checkLoggedIn();
    super.initState();
  }

  Future<void> _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';
    if (email.isNotEmpty && password.isNotEmpty) {
      emailController.text = email;
      passwordController.text = password;
      _login();
    }
  }

  Future<void> _login() async {
    final response = await http
        .post(Uri.parse('http://10.0.2.2:8000/api/auth/login'), body: {
      'email': emailController.text,
      'password': passwordController.text,
      'login_as': 'customer',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final data = jsonDecode(response.body);
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Login Failed"),
          content: Text(data['error']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("OK"),
            )
          ],
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
