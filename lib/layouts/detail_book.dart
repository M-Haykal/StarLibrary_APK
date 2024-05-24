import 'package:flutter/material.dart';
import 'package:starlibrary/pages/online_book.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Data buku;

  DetailPage({required this.buku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Product',
          style: TextStyle(color: Colors.black), 
        ),
        centerTitle: true, 
        backgroundColor: Colors.white, 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), 
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme:
            IconThemeData(color: Colors.black), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'http://perpus.amwp.website/' +
                    (buku.thumbnail ?? 'images/placeholder.jpg'),
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image_not_supported, size: 200);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              buku.judul ?? 'No Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Penerbit: ${buku.penerbit ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Pengarang: ${buku.pengarang ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Deskripsi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              buku.deskripsi ?? 'No Description',
              style: TextStyle(fontSize: 14),
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
                    onPressed: () {
                      final pdfUrl =
                          'http://perpus.amwp.website/' + (buku.pdfFile ?? '');
                      _launchURL(pdfUrl);
                    },
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

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
