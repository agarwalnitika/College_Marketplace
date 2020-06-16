import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/animations/typing.dart';
import 'package:marketplace/buy/product_details.dart';
import 'package:marketplace/common_widgets/donation_list_tile.dart';
import 'package:marketplace/common_widgets/empty_content.dart';
import 'package:marketplace/common_widgets/product_list_tile.dart';
import 'package:marketplace/donate/donation_event_details.dart';
import 'package:marketplace/models/donation.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';
import 'package:provider/provider.dart';

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
    final database = Provider.of<Database>(context);
    return  Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Donate'),
        ),
        body: Column(
          children: <Widget>[
           image_carousel,
           TypingTextAnimation(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Check out the upcoming events',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: StreamBuilder<List<DonationEvent>>(
                stream: database.allDonationsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final allDonations = snapshot.data;
                    if (allDonations.isNotEmpty) {
                      final children = allDonations
                          .map((donation) => DonationEventTile(
                        donation: donation,
                        onTap: () => Donation_Event_Details.show(
                          context,
                          donation: donation,
                        ),
                        height: 150,
                        width: 300,
                      ))
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

