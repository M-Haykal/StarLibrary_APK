import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlibrary/layouts/detail_book_offline.dart';
import 'package:starlibrary/layouts/fav.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

@override
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<Map<String, dynamic>> _bukus = [];
  List<Map<String, dynamic>> _borrowList = [];
  Timer? _timer;
  String _searchText = '';
  bool _isRefreshing = false;

  void _showModal(BuildContext context) {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) => _buildModalContent(context),
    );
  }

  Future<void> _getBorrowList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('id') ?? 0;

    final response = await http.get(
      Uri.parse('http://perpus.amwp.website/api/auth/listpeminjaman'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        setState(() {
          _borrowList = List<Map<String, dynamic>>.from(data['data']);
          // Filter the borrow list based on matching siswa_id
          _borrowList.removeWhere(
              (borrowItem) => borrowItem['siswa_id'] != id.toString());
        });
      }
    } else {
      print('Failed to fetch borrow list. Status code: ${response.statusCode}');
    }
  }

  Widget _buildModalContent(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              "Borrow List",
              style: GoogleFonts.montserrat(
                color: Color(0xFF800000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            color: Colors.grey[300],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _borrowList.length,
              itemBuilder: (context, index) {
                final borrowItem = _borrowList[index];
                return ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'http://perpus.amwp.website/storage/${borrowItem['thumbnail']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(borrowItem['judul'] ?? ''),
                  subtitle: Text(borrowItem['pengarang'] ?? ''),
                  trailing: Text(borrowItem['status'] ?? ''),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.close),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _buildBookCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Container(
          width: 80,
          height: 80,
          color: Colors.grey[300],
        ),
        title: Container(
          height: 15,
          color: Colors.grey[300],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Container(
              height: 10,
              width: 120,
              color: Colors.grey[300],
            ),
            SizedBox(height: 4),
            Container(
              height: 10,
              width: 100,
              color: Colors.grey[300],
            ),
            SizedBox(height: 4),
            Container(
              height: 10,
              width: 80,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getListBuku();
    _getBorrowList();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _getBorrowList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer to avoid memory leaks
    _timer?.cancel();
  }

  Future<void> _getListBuku() async {
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

      // Check if 'bukus' is present and is not null
      if (data['bukus'] != null) {
        setState(() {
          _bukus = List<Map<String, dynamic>>.from(data['bukus']);
        });
      } else {
        // Handle the case where 'bukus' is null or not present
        // For example, log an error or show a message
        print('Error: bukus is null or not present in the response');
      }
    } else {
      // Handle error response
      print(
          'Error: Failed to fetch list buku. Status code: ${response.statusCode}');
    }
  }

  void _performSearch(String query) {
    setState(() {
      _searchText = query;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    await _getListBuku();
    await _getBorrowList();
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;

    if (screenWidth < 492.002) {
      crossAxisCount = 1; // Small screen
    } else if (screenWidth < 900) {
      crossAxisCount = 2; // Medium screen
    } else if (screenWidth < 1200) {
      crossAxisCount = 3; // Medium screen
    } else {
      crossAxisCount = 4; // Large screen
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Now Reading",
          style: GoogleFonts.montserrat(
            color: Color(0xFF800000),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => PopupMenuButton<String>(
              onSelected: (value) {
                print('Selected: $value');
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Borrow',
                  child: Text('Borrow List'),
                  onTap: () {
                    _showModal(context);
                  },
                ),
                PopupMenuItem(
                  value: 'Favorite',
                  child: Text('Favorite Book'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookshelfScreen()),
                    );
                  },
                ),
                // Add more options as needed
              ],
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _isRefreshing ? 0.5 : 1.0,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pick of the day",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        )),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: _performSearch,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Most Popular",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )),
                      CarouselSlider(
                          items: [
                            Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2017/01/08/13/58/cube-1963036__340.jpg"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2017/01/08/13/58/cube-1963036__340.jpg"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2017/01/08/13/58/cube-1963036__340.jpg"),
                                    fit: BoxFit.cover),
                              ),
                            )
                          ],
                          options: CarouselOptions(
                              height: 180.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 0.8)),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Offline Book",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: _bukus.where((buku) {
                  final title = buku['judul'].toString().toLowerCase();
                  return title.contains(_searchText.toLowerCase());
                }).length,
                itemBuilder: (context, index) {
                  final filteredBukus = _bukus.where((buku) {
                    final title = buku['judul'].toString().toLowerCase();
                    return title.contains(_searchText.toLowerCase());
                  }).toList();

                  final buku = filteredBukus[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookOffline(bookId: buku['id']),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 3,
                      margin: EdgeInsets.all(3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.network(
                              'http://perpus.amwp.website/storage/${buku['thumbnail']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Title: ${buku['judul']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Publisher: ${buku['penerbit']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Author: ${buku['pengarang']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Book Stock: ${buku['stok_buku']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
    );
  }
}
