import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlibrary/pages/profile.dart';

void main() {
  runApp(EditProfileApp());
}

class EditProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileApp()),
      );
    },
        ),
        centerTitle: true,
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.person,
                          size: 80,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Username'),
            SizedBox(height: 5),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Email'),
            SizedBox(height: 5),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Make button full-width
              child: ElevatedButton(
                onPressed: () {
                  // Save the user's profile information
                  String username = _usernameController.text;
                  String email = _emailController.text;

                  // Perform your save operation here

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Profile updated successfully!'),
                  ));
                },
                child: Text("Save changes",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // Make button rectangular
                    ),
                    backgroundColor: Color(0xFF800000)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
