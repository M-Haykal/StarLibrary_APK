import 'package:flutter/material.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Saved Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ProfileScreen(),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 40.0),
        Row(
          children: [
            Icon(
              Icons.person,
              size: 30.0,
            ),
            SizedBox(width: 10.0),
            Text("Name"),
          ],
        ),
        SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          child: TextFormField(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Icon(
              Icons.email,
              size: 30.0,
            ),
            SizedBox(width: 10.0),
            Text("Email"),
          ],
        ),
        SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          child: TextFormField(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Icon(
              Icons.edit,
              size: 30.0,
            ),
            SizedBox(width: 10.0),
            Text("Edit Profile"),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Icon(
              Icons.exit_to_app,
              size: 30.0,
            ),
            SizedBox(width: 10.0),
            Text("Sign Out"),
          ],
        ),
        SizedBox(height: 40.0),
      ],
    );
  }
}
