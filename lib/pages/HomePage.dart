import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starlibrary/layouts/Navbar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

@override
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  void _showModal(BuildContext context) {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) => _buildModalContent(context),
    );
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
              style: TextStyle(
                fontSize: 20,
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
              itemCount: 10, // Ganti dengan jumlah buku yang Anda miliki
              itemBuilder: (context, index) {
                return _buildBookCard();
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
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
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _showModal(context);
            },
          ),
        ],
      ),
      body: ListView(
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
            child: Column(
              children: [
                Row(
                  children: [Card()],
                ),
                Row(),
                Row()
              ],
            ),
          )
        ],
      ),
    );
  }
}
