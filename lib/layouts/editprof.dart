import 'package:flutter/material.dart';
import 'package:image_input/image_input.dart';

void main() {
  runApp(EditProfileScreen());
}

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          centerTitle: true, // Align the title text to center
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: EditProfileForm(),
        ),
      ),
    );
  }
}

class EditProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            ProfileAvatar(
              radius: 100,
              allowEdit: true,
              backgroundColor: Colors.grey,
              addImageIcon: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add_a_photo),
                ),
              ),
              removeImageIcon: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
              ),
              onImageChanged: (XFile? image) {
                //save image to cloud and get the url
                //or
                //save image to local storage and get the path
                String? tempPath = image?.path;
                print(tempPath);
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Color(0xFF800000)), // Set border color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey), // Set border color when not focused
                ),
                labelStyle: TextStyle(color: Colors.grey), // Set label color
              ),
              cursorColor: Color(0xFF800000), // Set cursor color
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Email',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Color(0xFF800000)), // Set border color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey), // Set border color when not focused
                ),
                labelStyle: TextStyle(color: Colors.grey), // Set label color
              ),
              cursorColor: Color(0xFF800000), // Set cursor color
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle when the save button is clicked
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.brown,
            backgroundColor:
                Color(0xFF880000), // Set button text color when pressed
          ),
          child: Text(
            'Save Changes',
            style: TextStyle(color: Colors.white), // Set button text color
          ),
        ),
      ],
    );
  }
}
