import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              MaterialPageRoute(builder: (context) => Nav()),
            );
          },
          skipTextButton: Text('skip'),
          trailing: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()),
              );
            },
            child: Text('Login',),
          ),
          background: [
            Image.asset('assets/contoh.jpg'),
            Image.asset('assets/contoh.jpg'),
            Image.asset('assets/contoh.jpg'),
          ],
          totalPage: 3,
          speed: 1.8,
          pageBodies: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                  ),
                  Text('XI PPLG 1')
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                  ),
                  Text('XI PPLG 1')
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                  ),
                  Text('XI PPLG 1')
                ],
              ),
            )
          ]),
    );
  }
}
