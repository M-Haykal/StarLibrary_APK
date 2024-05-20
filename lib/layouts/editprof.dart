// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(EditProfileScreen());
// }

// class EditProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Edit Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//           backgroundColor: Colors.white,
//           centerTitle: true, // Align the title text to center
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(20.0),
//           child: EditProfileForm(),
//         ),
//       ),
//     );
//   }
// }

// class EditProfileForm extends StatefulWidget {
//   @override
//   _EditProfileFormState createState() => _EditProfileFormState();
// }

// class _EditProfileFormState extends State<EditProfileForm> {
//   late File _imageFile;

//   Future<void> _selectImage(BuildContext context) async {
//     final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = pickedFile as File;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               height: 100,
//             ),
//             GestureDetector(
//               onTap: () {
//                 _selectImage(context);
//               },
//               child: CircleAvatar(
//                 radius: 50,
//                 // Use FileImage if using image from gallery
//                 backgroundImage: _imageFile != null ? FileImage(_imageFile) : AssetImage('assets/contoh.jpg'),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: GestureDetector(
//                 onTap: () {
//                   // Handle when the camera icon is clicked
//                   // You can navigate to the gallery here
//                   _selectImage(context);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                   ),
//                   child: Icon(
//                     Icons.camera_alt,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 20),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Name',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(width: 10),
//               ],
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 hintText: 'Enter your name',
//                 border: OutlineInputBorder(),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF800000)), // Set border color when focused
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey), // Set border color when not focused
//                 ),
//                 labelStyle: TextStyle(color: Colors.grey), // Set label color
//               ),
//               cursorColor: Color(0xFF800000), // Set cursor color
//             ),
//           ],
//         ),
//         SizedBox(height: 20),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Email',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(width: 10),
//               ],
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 hintText: 'Enter your email',
//                 border: OutlineInputBorder(),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF800000)), // Set border color when focused
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey), // Set border color when not focused
//                 ),
//                 labelStyle: TextStyle(color: Colors.grey), // Set label color
//               ),
//               cursorColor: Color(0xFF800000), // Set cursor color
//             ),
//           ],
//         ),
//         SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             // Handle when the save button is clicked
//           },
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.brown, backgroundColor: Color(0xFF880000), // Set button text color when pressed
//           ),
//           child: Text(
//             'Save Changes',
//             style: TextStyle(color: Colors.white), // Set button text color
//           ),
//         ),
//       ],
//     );
//   }
// }
