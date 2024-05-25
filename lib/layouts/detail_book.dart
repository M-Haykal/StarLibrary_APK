import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starlibrary/pages/online_book.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class DetailPage extends StatelessWidget {
  final Data buku;

  DetailPage({required this.buku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Offline Book Detail",
          style: GoogleFonts.montserrat(
            color: Colors.black,
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
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
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'http://perpus.amwp.website/storage/' +
                          (buku.thumbnail ?? 'images/placeholder.jpg'),
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image_not_supported, size: 200);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                buku.judul ?? 'No Title',
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Penerbit: ${buku.penerbit ?? 'Unknown'}',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Pengarang: ${buku.pengarang ?? 'Unknown'}',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Deskripsi',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 8),
              Text(
                buku.deskripsi ?? 'No Description',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 5,
                      ),
                      child: Text(
                        'Favorite',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerFromUrl(
                              url: 'http://perpus.amwp.website/storage/' +
                                  (buku.pdfFile ?? ''),
                              title: buku.judul ?? 'PDF From Url',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFd32f2f),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 5,
                      ),
                      child: Text(
                        'Reading Now',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url, required this.title})
      : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: progress / 100,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'Loading... ${progress.toStringAsFixed(0)}%',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
