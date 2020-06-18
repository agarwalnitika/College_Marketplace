import 'package:flutter/material.dart';
import 'package:marketplace/administration/show_categories.dart';
import 'package:marketplace/administration/show_donations.dart';
import 'package:marketplace/administration/show_products.dart';
import 'package:marketplace/drawer/drawer.dart';
import 'package:marketplace/drawer/my_account.dart';
import 'package:marketplace/screens/buy_page.dart';
import 'package:marketplace/screens/donation_page.dart';
import 'package:marketplace/screens/sell_page.dart';
import 'admin_manage.dart';

class AdminHome extends StatefulWidget {

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static int selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }




  static List<dynamic> _widgetOptions = <Widget>[
    Buy(),
    AdminPage(),
    ShowCategories(),
    ShowProducts(),
    Donation(),
    DonationAds(),
    MyAccount(),

  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white70,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Manage'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Products'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            title: Text('Donate'),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Donations'),
          ), BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('My Account'),
          ),

        ],
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}
