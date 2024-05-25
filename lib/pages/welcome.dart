import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starlibrary/pages/HomePage.dart';
import 'package:starlibrary/pages/RegistrasionPage.dart';
import 'package:starlibrary/pages/LoginPage.dart';
import 'package:starlibrary/layouts/Navbar.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingSlider(
          headerBackgroundColor: Colors.white,
          finishButtonText: 'Register',
          finishButtonStyle: FinishButtonStyle(
            backgroundColor: Color(0xFF800000),
          ),
          onFinish: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          skipTextButton: Text(
            '',
            style: GoogleFonts.montserrat(
              color: Color(0xFF800000),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Login',
              style: GoogleFonts.montserrat(
                color: Color(0xFF800000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          background: [
            Container(
                color: Color(
                    0xFF800000)), // Ubah warna latar belakang sesuai keinginan Anda
            Container(
                color: Color(
                    0xFF800000)), // Ubah warna latar belakang sesuai keinginan Anda
            Container(
                color: Color(
                    0xFF800000)), // Ubah warna latar belakang sesuai keinginan Anda
          ],
          totalPage: 3,
          speed: 1.8,
          pageBodies: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                    child: Image.asset('assets/part2.png'),
                  ),
                  Text(
                    'StarLibrary',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF800000),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                    child: Image.asset('assets/part3.png'),
                  ),
                  Text(
                    'Create By XI PPLG 1',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF800000),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                    child: Image.asset('assets/part1.png'),
                  ),
                  Text(
                    'Let’s Get Started',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF800000),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          ]),
    );
  }
}
