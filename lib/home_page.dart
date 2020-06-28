import 'package:flutter/material.dart';
import 'package:marketplace/drawer/drawer.dart';
import 'package:marketplace/drawer/my_account.dart';
import 'package:marketplace/screens/buy_page.dart';
import 'package:marketplace/screens/donation_page.dart';
import 'package:marketplace/screens/sell_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<dynamic> _widgetOptions = <Widget>[
    Buy(),
    MyProducts(),
    Donation(),
    MyAccount(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            title: Text('Sell'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Donate'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            title: Text('My Account'),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}
