import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/animations/typing.dart';
import 'package:marketplace/buy/product_details.dart';
import 'package:marketplace/common_widgets/donation_list_tile.dart';
import 'package:marketplace/common_widgets/empty_content.dart';
import 'package:marketplace/common_widgets/product_list_tile.dart';
import 'package:marketplace/common_widgets/quad_clipper.dart';
import 'package:marketplace/donate/donation_event_details.dart';
import 'package:marketplace/models/donation.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';

class Donation extends StatefulWidget {
  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  double width;

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 80,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.brighter,
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 10,
                right: -120,
                child: _circularContainer(200, LightColor.lightBlue),
              ),
              Positioned(
                  top: -60,
                  left: -65,
                  child: _circularContainer(width * .5, LightColor.darkBlue)),
              Positioned(
                  top: -230,
                  right: -30,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Colors.white38)),
              Positioned(
                  top: 40,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Donate",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      ))),
            ],
          )),
    );
  }

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
    final database = Provider.of<Database>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          _header(context),
          image_carousel,
          TypingTextAnimation(),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Text(
              'Check out the upcoming events',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: StreamBuilder<List<DonationEvent>>(
                    stream: database.allDonationsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final allDonations = snapshot.data;
                        if (allDonations.isNotEmpty) {
                          final children = allDonations
                              .map(
                                (donation) => GestureDetector(
                                  onTap: () => Donation_Event_Details.show(
                                    context,
                                    donation: donation,
                                  ),
                                  child: _card(
                                      primary: Colors.white,
                                      chipColor: LightColor.lightBlue,
                                      backWidget: _decorationContainerE(
                                        LightColor.lightBlue,
                                        90,
                                        -40,
                                        secondary: LightColor.lightseeBlue,
                                      ),
                                      chipText1: donation.name,
                                      chipText2: donation.date,
                                      imgPath:
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRqpYuGuB4yx_GpIvulgpOC99kNvnwuoXNqAcJf3d3aXv4TT1yN&usqp=CAU"),
                                ),
                              )
                              .toList();
                          return ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: children,
                          );
                        }
                        return EmptyContent(
                          title: 'Nothing Here',
                          message: 'No Events to show',
                        );
                      }
                      if (snapshot.hasError) {
                        return EmptyContent(
                          title: 'Something went wrong',
                          message: 'Can\'t load items right now',
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _decorationContainerE(Color primary, double top, double left,
    {Color secondary}) {
  return Stack(
    children: <Widget>[
      Positioned(
        top: -105,
        left: -35,
        child: CircleAvatar(
          radius: 70,
          backgroundColor: primary.withAlpha(100),
        ),
      ),
      Positioned(
          top: 40,
          right: -25,
          child: ClipRect(
              clipper: QuadClipper(),
              child: CircleAvatar(backgroundColor: primary, radius: 40))),
      Positioned(
          top: 45,
          right: -50,
          child: ClipRect(
              clipper: QuadClipper(),
              child: CircleAvatar(backgroundColor: secondary, radius: 50))),
      _smallContainer(LightColor.yellow, 15, 90, radius: 5)
    ],
  );
}

Positioned _smallContainer(Color primary, double top, double left,
    {double radius = 10}) {
  return Positioned(
      top: top,
      left: left,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: primary.withAlpha(255),
      ));
}

Widget _card(
    {Color primary = LightColor.darkseeBlue,
    String imgPath,
    String chipText1 = '',
    String chipText2 = '',
    Widget backWidget,
    Color chipColor = LightColor.lightBlue,
    bool isPrimaryCard = false}) {
  return Container(
      height: isPrimaryCard ? 300 : 300,
      width: isPrimaryCard ? 400 * .32 : 600 * .32,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
          color: primary.withAlpha(200),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 10,
                color: LightColor.lightpurple.withAlpha(20))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          child: Stack(
            children: <Widget>[
              backWidget,
              Positioned(
                  top: 20,
                  left: 10,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: NetworkImage(imgPath),
                  )),
              Positioned(
                bottom: 10,
                left: 10,
                child: _cardInfo(
                    chipText1, chipText2, LightColor.titleTextColor, chipColor,
                    isPrimaryCard: isPrimaryCard),
              )
            ],
          ),
        ),
      ));
}

Widget _cardInfo(String title, String courses, Color textColor, Color primary,
    {bool isPrimaryCard = false}) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 10),
          width: 400 * .32,
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isPrimaryCard ? Colors.white : textColor),
          ),
        ),
        SizedBox(height: 5),
        _chip(courses, primary, height: 5, isPrimaryCard: isPrimaryCard)
      ],
    ),
  );
}

Widget _chip(String text, Color textColor,
    {double height = 0, bool isPrimaryCard = false}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
    ),
    child: Text(
      text,
      style: TextStyle(
          color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
    ),
  );
}

Widget _circularContainer(double height, Color color,
    {Color borderColor = Colors.transparent, double borderWidth = 2}) {
  return Container(
    height: height,
    width: height,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      border: Border.all(color: borderColor, width: borderWidth),
    ),
  );
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
