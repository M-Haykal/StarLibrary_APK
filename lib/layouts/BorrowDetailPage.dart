import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BorrowDetailPage extends StatefulWidget {
  final Map<String, dynamic> borrowItem;

  BorrowDetailPage({required this.borrowItem});

  @override
  _BorrowDetailPageState createState() => _BorrowDetailPageState();
}

class _BorrowDetailPageState extends State<BorrowDetailPage> {
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  late double _rating;
  String _review = '';
  late String _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    final dateTime = DateTime.parse(dateStr);
    return dateFormatter.format(dateTime);
  }

  Future<void> _cancelBorrowing(BuildContext context) async {
    final url =
        'http://perpus.amwp.website/api/auth/cancel/${widget.borrowItem['id']}';
    final response = await http.put(Uri.parse(url));

    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Success",
        desc: "Peminjaman berhasil dibatalkan",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Gagal membatalkan peminjaman",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  Future<void> _submitReview(BuildContext context) async {
    final url = 'http://perpus.amwp.website/api/auth/ulasan';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    int? userId = prefs.getInt('id');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'buku_id': widget.borrowItem['buku_id'],
        'peminjaman_id': widget.borrowItem[
            'id'], // Assuming peminjaman_id is the same as borrowItem id
        'comment': _review,
        'rating': _rating,
        'siswa_id': userId,
      }),
    );

    final responseJson = jsonDecode(response.body);
    final responseMessage = responseJson['message'] ?? 'Unknown error';

    if (response.statusCode == 200) {
      // Show success dialog
      Alert(
        context: context,
        type: AlertType.success,
        title: "Pesan",
        desc: responseMessage,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      // Show error dialog
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: responseMessage,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.borrowItem['judul'] ?? 'Borrow Detail'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.borrowItem['thumbnail'] != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      'http://perpus.amwp.website/storage/${widget.borrowItem['thumbnail']}',
                      height: 250, // Set a smaller height
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                widget.borrowItem['judul'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          'Pengarang', widget.borrowItem['pengarang'] ?? ''),
                      _buildDetailRow(
                          'Penerbit', widget.borrowItem['penerbit'] ?? ''),
                      _buildDetailRow(
                          'Denda', widget.borrowItem['denda'] ?? ''),
                      _buildDetailRow(
                          'Deskripsi', widget.borrowItem['deskripsi'] ?? 'N/A'),
                      _buildDetailRow(
                          'Status', widget.borrowItem['status'] ?? ''),
                      _buildDetailRow('Created At',
                          formatDate(widget.borrowItem['created_at'])),
                      _buildDetailRow('Confirmed At',
                          formatDate(widget.borrowItem['confirmed_at'])),
                      _buildDetailRow('Returned At',
                          formatDate(widget.borrowItem['returned_at'])),
                    ],
                  ),
                ),
              ),
              if (widget.borrowItem['status'] == 'waiting')
                Center(
                  child: ElevatedButton(
                    onPressed: () => _cancelBorrowing(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Batalkan Peminjaman'),
                  ),
                ),
              if (widget.borrowItem['status'] == 'returned') ...[
                SizedBox(height: 20),
                Text(
                  'Rate this book:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Rating stars
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false, // Disable half rating
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(height: 10),
                // Review input
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _review = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Write your review',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                // Submit review button
                ElevatedButton(
                  onPressed: () => _submitReview(context),
                  child: Text('Submit Review'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
