import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/animations/typing.dart';

class Donation extends StatefulWidget {
  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  Widget image_carousel = new Container(
    height: 300,
    child: Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('assets/donation1.jpg'),
        AssetImage('assets/donation3.jpg'),
        AssetImage('assets/donation4.jpg'),
        AssetImage('assets/donation2.webp'),
        AssetImage('assets/donation5.jpg'),
      ],
      animationCurve: Curves.fastOutSlowIn,
      autoplay: true,
      animationDuration: Duration(milliseconds: 1000),
    ),
  );
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Donate'),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
               image_carousel,
               TypingTextAnimation(),
                Text('gi'),
              ],
            ),
          ],
        ),
    );
  }
}

Widget images(int number) {
  var my_img = [
    'assets/donation1.jpg',
    'assets/donation3.jpg',
    'assets/donation4.jpg',
    'assets/donation2.webp',
    'assets/donation5.jpg'
  ];
  return Container(
    width: 400,
    height: 320,
    child: Image.asset(my_img[number], fit: BoxFit.fill),
  );
}

