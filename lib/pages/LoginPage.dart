import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:starlibrary/layouts/Navbar.dart';
import 'package:starlibrary/pages/RegistrasionPage.dart';
import 'package:starlibrary/pages/HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
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
    final response = await http.post(
      Uri.parse('http://perpus.amwp.website/api/auth/login'),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
        'login_as': 'costumer',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];
      String profile = data['user']['profile_picture'];
      String nama = data['user']['nama'];
      String email = data['user']['email'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('profile', profile);
      await prefs.setString('nama', nama);
      await prefs.setString('email', email);
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Nav()),
      );
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi, Welcome!",
          style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          "Please enter your username/email and password to sign in",
          style:
              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.grey.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forgot password?",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _login();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color(0xFF800000),
          ),
          child: Text("Login",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              )),
        )
      ],
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            child: Text(
              "Sign Up",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
