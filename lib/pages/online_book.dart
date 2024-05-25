import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:starlibrary/layouts/detail_book.dart';

class OnlineBook extends StatefulWidget {
  const OnlineBook({super.key});

  @override
  State<OnlineBook> createState() => _OnlineBookState();
}

class _OnlineBookState extends State<OnlineBook> {
  Future<Autogenerated>? futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<Autogenerated> fetchData() async {
    final response =
        await http.get(Uri.parse('http://perpus.amwp.website/api/auth/online'));

    if (response.statusCode == 200) {
      return Autogenerated.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Online Book",
          style: GoogleFonts.montserrat(
            color: Color(0xFF800000),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pick of the day",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder<Autogenerated>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.data == null) {
                      return Center(child: Text('No Data Available'));
                    } else {
                      final data = snapshot.data!.data!;
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(buku: item),
                                ),
                              );
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 3,
                              margin: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Image.network(
                                      'http://perpus.amwp.website/' +
                                          (item.thumbnail ?? ''),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.image_not_supported);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Title: ${item.judul}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Autogenerated {
  bool? success;
  List<Data>? data;

  Autogenerated({this.success, this.data});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? judul;
  String? penerbit;
  String? pengarang;
  String? stokBuku;
  String? category;
  String? deskripsi;
  String? thumbnail;
  String? pdfFile;

  Data(
      {this.id,
      this.judul,
      this.penerbit,
      this.pengarang,
      this.stokBuku,
      this.category,
      this.deskripsi,
      this.thumbnail,
      this.pdfFile});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judul = json['judul'];
    penerbit = json['penerbit'];
    pengarang = json['pengarang'];
    stokBuku = json['stok_buku'];
    category = json['category'];
    deskripsi = json['deskripsi'];
    thumbnail = json['thumbnail'];
    pdfFile = json['pdf_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['judul'] = this.judul;
    data['penerbit'] = this.penerbit;
    data['pengarang'] = this.pengarang;
    data['stok_buku'] = this.stokBuku;
    data['category'] = this.category;
    data['deskripsi'] = this.deskripsi;
    data['thumbnail'] = this.thumbnail;
    data['pdf_file'] = this.pdfFile;
    return data;
  }
}
