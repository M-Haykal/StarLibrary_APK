import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BookOffline(),
    );
  }
}

class BookOffline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Borrow', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Add your code here
          },
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                'images/buku_coding.jpg', // Replace with your image URL
                height: 150,
              ),
              SizedBox(height: 16),
              Text(
                'Filosofi Teras',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Filosofi Teras adalah buku karya Henry Manampiring yang memperkenalkan filsafat Stoisisme kepada pembaca Indonesia. Buku ini bertujuan untuk membantu pembaca memahami dan menerapkan prinsip-prinsip Stoisisme dalam kehidupan sehari-hari untuk mencapai ketenangan jiwa dan kebahagiaan.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Author Book: Henry Manampiring',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Stock Book: 20',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text('Borrow', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF800000), // Set the button color to #800000
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}