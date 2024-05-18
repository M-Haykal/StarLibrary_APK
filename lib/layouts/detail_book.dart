import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Detail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookDetailPage(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class BookDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Product',
          style: TextStyle(color: Colors.black), // Set the title color to black
        ),
        centerTitle: true, // Center the title
        backgroundColor: Colors.white, // Set the AppBar color to white
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
          onPressed: () {
            // Handle back button press
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: Colors.black), // Set the icon color to black
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'images/buku_coding.jpg', // Replace with your book cover image URL
                height: 200,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'The Great Book Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16), // Adjusted the spacing after removing the prices
            Text(
              'Deskripsi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quasi, eum? Id, culpa? At officia quisquam laudantium nisi mollitia nesciunt, qui porro asperiores cum voluptates placeat similique recusandae in facere quos vitae?',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '100% good reviews\n7 days returns\nWarranty not applicable',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                    ),
                    child: Text('Favorite'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Reading Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}