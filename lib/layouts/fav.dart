import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true, // Ensuring the title is centered
        ),
      ),
      home: BookshelfScreen(),
    );
  }
}

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  List<dynamic> _favorites = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    int? userId = prefs.getInt('id');

    if (token.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: No token or user ID found. Please log in.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final response = await http.get(
      Uri.parse(
          'http://perpus.amwp.website/api/auth/favorite?siswa_id=$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _favorites = data['favorites']
            .where((favorite) => favorite['siswa_id'] == userId.toString())
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error: Failed to fetch favorites. Status code: ${response.statusCode}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _removeFromFavorites(int bookId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    int? userId = prefs.getInt('id');

    if (token.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: No token or user ID found. Please log in.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final response = await http.delete(
      Uri.parse('http://perpus.amwp.website/api/auth/favorite'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'siswa_id': userId,
        'buku_id': bookId,
      }),
    );

    if (response.statusCode == 200) {
      // Refresh favorites after removal
      _fetchFavorites();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Book removed from favorites successfully!'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error: Failed to remove book from favorites. Status code: ${response.statusCode}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Book',
          style: GoogleFonts.montserrat(
            color: Color(0xFF800000),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme:
            IconThemeData(color: Colors.black), // Ensure icon color is black
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Use the arrow back icon
          onPressed: () {
            // Define the action when the icon is pressed
            // For example, navigate to the previous screen
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8), // Add some top padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Your favorite book here',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _favorites.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      height: 400, // Set a specific height for the grid
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _favorites.length,
                        itemBuilder: (context, index) {
                          final favorite = _favorites[index]['buku'];
                          return GestureDetector(
                            onTap: () {
                              // Define the action when the book is tapped
                              // For example, navigate to book details screen
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Image.network(
                                        'http://perpus.amwp.website/storage/${favorite['thumbnail']}',
                                        fit: BoxFit.cover,
                                        height: 85,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          favorite['judul'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () {
                                        // Remove from favorites
                                        _removeFromFavorites(favorite['id']);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
