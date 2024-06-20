import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  double? _averageRating;

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
    _fetchReviews().then((_) {
      _calculateAverageRating();
    });
  }

  Future<void> _fetchBookDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
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

  Future<void> _calculateAverageRating() async {
    if (_reviews.isEmpty) {
      setState(() {
        _averageRating = null;
      });
      return;
    }

    double totalRating = 0;
    for (var review in _reviews) {
      totalRating += double.parse(review['rating']);
    }
    double averageRating = totalRating / _reviews.length;

    setState(() {
      _averageRating = averageRating;
    });
  }

  Future<void> _borrowBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      _showAlertDialog(
          'Error', 'No token found. Please log in.', Colors.red, Icons.error);
      return;
    }

    final response = await http.post(
      Uri.parse('http://perpus.amwp.website/api/auth/pinjam/${widget.bookId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      _showAlertDialog(
          'Success', 'Peminjaman sukses!', Colors.green, Icons.check_circle);
    } else if (response.statusCode == 409) {
      _showAlertDialog(
          'Info', 'Buku sudah dipinjam.', Colors.orange, Icons.error);
    } else if (response.statusCode == 400) {
      _showAlertDialog('Info', 'Buku Habis.', Colors.orange, Icons.error);
    } else {
      _showAlertDialog(
          'Error',
          'Failed to borrow book. Status code: ${response.statusCode}',
          Colors.red,
          Icons.error);
    }
  }

  void _showAlertDialog(
      String title, String message, Color color, IconData iconData) {
    Alert(
      context: context,
      type: AlertType.none,
      title: '',
      content: Column(
        children: [
          Icon(
            iconData,
            size: 50,
            color: color,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(message),
        ],
      ),
      style: AlertStyle(
        isCloseButton: false,
        animationType: AnimationType.grow,
        titleStyle: TextStyle(color: color),
        descStyle: TextStyle(color: Colors.black),
      ),
      buttons: [
        DialogButton(
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
          color: color,
        ),
      ],
    ).show();
  }

  Future<void> _addToFavorite() async {
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

    final response = await http.post(
      Uri.parse('http://perpus.amwp.website/api/auth/favorite'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'siswa_id': userId,
        'buku_id': widget.bookId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Book added to favorites successfully!'),
        backgroundColor: Colors.green,
      ));
    } else if (response.statusCode == 409) {
      final responseData = jsonDecode(response.body);
      if (responseData['message'] == 'Buku sudah ada di favorit') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The book is already in your favorites.'),
          backgroundColor: Colors.orange,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Error: Failed to add book to favorites. Status code: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error: Failed to add book to favorites. Status code: ${response.statusCode}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
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
        title: Text(
          _bookDetails!['judul'],
          style: GoogleFonts.montserrat(
            color: Color(0xFF800000),
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    height: constraints.maxWidth * 3 / 4,
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
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _bookDetails!['deskripsi'] ?? 'No description available',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Author: ${_bookDetails!['pengarang']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Publisher: ${_bookDetails!['penerbit']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Stock: ${_bookDetails!['stok_buku']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Average Rating: ',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  _buildAverageRatingStars(
                      _averageRating ?? 0), // Call the widget here

                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      ElevatedButton(
                        onPressed: _addToFavorite,
                        child: Row(
                          children: [
                            Icon(Icons.favorite_border, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Add to Favorite',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Review Book Section (Commented out)
                          SizedBox(height: 24),
                          Text(
                            'Reviews',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 500, // Set the desired height here
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        NeverScrollableScrollPhysics(), // Prevent internal scrolling
                                    itemCount: _reviews.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 3,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  _buildRatingStars(int.parse(
                                                      _reviews[index]
                                                          ['rating'])),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    _reviews[index]
                                                        ['user_name'],
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    _formatDate(_reviews[index]
                                                        ['created_at']),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                _reviews[index]['comment'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
        // Recalculate average rating
        _calculateAverageRating();
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

  Widget _buildAverageRatingStars(double averageRating) {
    int fullStars = averageRating.floor();
    double remainder = averageRating - fullStars;

    List<Widget> stars = List.generate(5, (index) {
      if (index < fullStars) {
        return Icon(Icons.star, color: Colors.amber);
      } else if (index == fullStars && remainder > 0) {
        // If there's a remainder, render a half-star
        return Icon(Icons.star_half, color: Colors.amber);
      } else {
        return Icon(Icons.star_border, color: Colors.amber);
      }
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...stars,
        SizedBox(width: 4), // Spacer between stars and average rating value
        Text(
          averageRating.toStringAsFixed(
              1), // Display average rating with one decimal place
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat.yMMMd().format(dateTime);
  }
}
