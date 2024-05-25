import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BookOffline extends StatefulWidget {
  final int bookId;

  BookOffline({required this.bookId});

  @override
  _BookOfflineState createState() => _BookOfflineState();
}

class _BookOfflineState extends State<BookOffline> {
  Map<String, dynamic>? _bookDetails;
  int _rating = 0;
  TextEditingController _reviewController = TextEditingController();
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
    _fetchReviews();
  }

  Future<void> _fetchBookDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      // If no token is found, display a message or take other action
      return;
    }

    final response = await http.get(
      Uri.parse('http://perpus.amwp.website/api/auth/listbuku'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['bukus'] != null) {
        final book = List<Map<String, dynamic>>.from(data['bukus']).firstWhere(
            (book) => book['id'] == widget.bookId,
            orElse: () => {});

        setState(() {
          _bookDetails = book;
        });
      } else {
        print('Error: bukus is null or not present in the response');
      }
    } else {
      print(
          'Error: Failed to fetch book details. Status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      // If no token is found, display a message or take other action
      return;
    }

    final response = await http.get(
      Uri.parse('http://perpus.amwp.website/api/auth/reviews/${widget.bookId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['reviews'] != null) {
        setState(() {
          _reviews = List<Map<String, dynamic>>.from(data['reviews']);
          // Sort reviews by created_at date
          _reviews.sort((a, b) => DateTime.parse(b['created_at'])
              .compareTo(DateTime.parse(a['created_at'])));
        });
      } else {
        print('Error: reviews is null or not present in the response');
      }
    } else {
      print(
          'Error: Failed to fetch reviews. Status code: ${response.statusCode}');
    }
  }

  Future<void> _borrowBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: No token found. Please log in.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final response = await http.post(
      Uri.parse('http://perpus.amwp.website/api/auth/pinjam/${widget.bookId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Book borrowed successfully!'),
        backgroundColor: Colors.green,
      ));
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Book is already borrowed.'),
        backgroundColor: Colors.orange,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error: Failed to borrow book. Status code: ${response.statusCode}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bookDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            Text(_bookDetails!['judul'], style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: constraints.maxWidth * 3 / 4, // Aspect ratio 4:3
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(0, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'http://perpus.amwp.website/storage/${_bookDetails!['thumbnail']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _bookDetails!['judul'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _bookDetails!['deskripsi'] ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Author: ${_bookDetails!['pengarang']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Publisher: ${_bookDetails!['penerbit']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Stock: ${_bookDetails!['stok_buku']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _borrowBook,
                    child: Text(
                      'Borrow',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF800000),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      labelText: 'Write a Review',
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text(
                      'Submit Review',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildRatingStars(
                                      int.parse(_reviews[index]['rating'])),
                                  SizedBox(width: 8),
                                  Text(
                                    _reviews[index]['user_name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    _formatDate(_reviews[index]['created_at']),
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(_reviews[index]['comment']),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  Future<void> _submitReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    int? userId = prefs.getInt('id');
    String nama = prefs.getString('nama') ?? 'User';

    if (token.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: No token or user ID found. Please log in.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    String review = _reviewController.text.trim();
    if (review.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://perpus.amwp.website/api/auth/ulasan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'buku_id': widget.bookId,
          'comment': review,
          'rating': _rating,
          'siswa_id': userId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _reviews.add({
            'user_name': nama,
            'rating': _rating.toString(),
            'comment': review,
            'created_at': DateTime.now().toString(),
          });
          _reviewController.clear();
          _rating = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Error: Failed to submit review. Status code: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating) {
          return Icon(Icons.star, color: Colors.amber);
        } else {
          return Icon(Icons.star_border, color: Colors.amber);
        }
      }),
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat.yMMMd().format(dateTime);
  }
}
