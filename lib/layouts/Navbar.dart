import 'package:flutter/material.dart';
import 'package:starlibrary/pages/HomePage.dart';
import 'package:starlibrary/pages/profile.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text('Online Book'),
    ProfileApp()
  ];

  Color _iconColor = Color(0xFF800000);
  Color _selectedIconColor = Colors.black;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0 ? _selectedIconColor : _iconColor),
            ),
            BottomNavigationBarItem(
              label: 'Online Book',
              icon: Icon(Icons.book_outlined,
                  color: _selectedIndex == 1 ? _selectedIconColor : _iconColor),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.person,
                  color: _selectedIndex == 2 ? _selectedIconColor : _iconColor),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
          selectedItemColor: _selectedIconColor,
          unselectedItemColor: _iconColor,
        ),
      ),
    );
  }
}
