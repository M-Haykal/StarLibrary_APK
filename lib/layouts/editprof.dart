import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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
  String? _profileImageUrl;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('nama');
    String? email = prefs.getString('email');
    String? profilePath = prefs.getString('profile');
    String baseUrl = 'http://perpus.amwp.website/storage/';

    setState(() {
      if (username != null) {
        _usernameController.text = username;
      }
      if (email != null) {
        _emailController.text = email;
      }
      if (profilePath != null) {
        _profileImageUrl = '$baseUrl$profilePath';
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? croppedFile = await _cropImageToSquare(File(pickedFile.path));
      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
        });
      }
    }
  }

  Future<File?> _cropImageToSquare(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final originalImage = await decodeImageFromList(bytes);

    int originalWidth = originalImage.width;
    int originalHeight = originalImage.height;

    int cropSize =
        originalWidth < originalHeight ? originalWidth : originalHeight;

    int offsetX = (originalWidth - cropSize) ~/ 2;
    int offsetY = (originalHeight - cropSize) ~/ 2;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final srcRect = Rect.fromLTWH(offsetX.toDouble(), offsetY.toDouble(),
        cropSize.toDouble(), cropSize.toDouble());
    final dstRect =
        Rect.fromLTWH(0, 0, cropSize.toDouble(), cropSize.toDouble());

    canvas.drawImageRect(originalImage, srcRect, dstRect, Paint());

    final croppedImage =
        await recorder.endRecording().toImage(cropSize, cropSize);
    final croppedBytes =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);

    final directory = await getApplicationDocumentsDirectory();
    final croppedFile = File(path.join(directory.path, 'cropped_image.png'));

    await croppedFile.writeAsBytes(croppedBytes!.buffer.asUint8List());

    return croppedFile;
  }

  Future<void> _saveProfileData() async {
    String username = _usernameController.text;
    String email = _emailController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    String? password = prefs.getString('password');

    if (id == null || password == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User ID or password not found in shared preferences!'),
      ));
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://perpus.amwp.website/api/auth/edit-profile'));
    request.fields['id'] = id.toString();
    request.fields['nama'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;

    if (_image != null) {
      String mimeType = lookupMimeType(_image!.path)!;
      var multipartFile = await http.MultipartFile.fromPath(
        'profile_picture',
        _image!.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      // Update SharedPreferences with the new data
      await prefs.setString('nama', jsonResponse['siswa']['nama']);
      await prefs.setString('email', jsonResponse['siswa']['email']);
      await prefs.setString(
          'profile', jsonResponse['siswa']['profile_picture']);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update profile!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                  backgroundImage: _getImageProvider(),
                  child: _getImageProvider() == null
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
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfileData,
                child: Text("Save changes",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: Color(0xFF800000)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider<Object>? _getImageProvider() {
    if (_image != null) {
      return FileImage(_image!);
    } else if (_profileImageUrl != null) {
      return NetworkImage(_profileImageUrl!);
    } else {
      return null;
    }
  }
}
