import 'package:flutter/material.dart';
import 'package:starlibrary/layouts/editprof.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlibrary/pages/LoginPage.dart';
import 'package:starlibrary/pages/welcome.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('profile');
    await prefs.remove('nama'); // Remove stored name
    await prefs.remove('email'); // Remove stored email

    // Replace the current page with LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Welcome()),
    );
  }

  Future<String> _getProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profilePath = prefs.getString('profile') ?? 'default_profile.png';
    String baseUrl = 'http://perpus.amwp.website/storage/';
    return '$baseUrl$profilePath';
  }

  Future<String> _getStoredName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nama') ?? 'John Doe';
  }

  Future<String> _getStoredEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? 'john.doe@example.com';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Profile",
            style: GoogleFonts.montserrat(
              color: Color(0xFF800000),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: FutureBuilder(
          future: Future.wait(
              [_getProfileImage(), _getStoredName(), _getStoredEmail()]),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading data'));
            } else {
              String profileImageUrl = snapshot.data![0];
              String name = snapshot.data![1];
              String email = snapshot.data![2];
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Name:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Email:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileApp()),
                            );
                          },
                          icon: Icon(Icons.edit),
                          label: Text('Edit Profile'),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            _logout(context);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 5),
                              Text(
                                'Logout',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
