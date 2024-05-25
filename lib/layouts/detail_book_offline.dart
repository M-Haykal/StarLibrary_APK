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

class BookOffline extends StatefulWidget {
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookOffline> {
  int _rating = 0;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final List<Map<String, dynamic>> _reviews = [];

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  void _addReview() {
    final nickname = _nicknameController.text;
    final review = _reviewController.text;

    if (nickname.isNotEmpty && review.isNotEmpty) {
      setState(() {
        _reviews
            .add({'nickname': nickname, 'review': review, 'rating': _rating});
        _nicknameController.clear();
        _reviewController.clear();
        _rating = 0; // Reset rating after submitting review
      });
    }
  }

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
            Navigator.of(context).pop();
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
                  backgroundColor:
                      Color(0xFF800000), // Set the button color to #800000
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => _setRating(index + 1),
                  );
                }),
              ),
              SizedBox(height: 16),
              Text(
                'Add Detail Review',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your nickname',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your review here...',
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addReview,
                child: Text('Submit Review',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Set the button color to grey
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Reviews:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: _reviews.map((review) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(review['nickname'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < review['rating']
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              );
                            }),
                          ),
                          Text(review['review'] ?? ''),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
