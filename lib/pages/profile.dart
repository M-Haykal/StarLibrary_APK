import 'package:flutter/material.dart';
import 'package:starlibrary/layouts/editprof.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlibrary/pages/welcome.dart';

class ProfileApp extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Welcome()),
      (route) => false,
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

  Future<int> _getStoredId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: GoogleFonts.montserrat(
            color: Color(0xFF800000),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: Future.wait(
          [
            _getProfileImage(),
            _getStoredName(),
            _getStoredEmail(),
            _getStoredId()
          ],
        ),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            String profileImageUrl = snapshot.data![0];
            String name = snapshot.data![1];
            String email = snapshot.data![2];
            int id = snapshot.data![3];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                    SizedBox(height: 20),
                    Text(
                      name,
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF800000),
                      ),
                    ),
                    Text(
                      '#$id',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person, color: Color(0xFF800000)),
                      title: Text(
                        'Name',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        name,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Color(0xFF800000)),
                      title: Text(
                        'Email',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        email,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF800000),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        _logout(context);
                      },
                      icon: Icon(Icons.logout),
                      label: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
