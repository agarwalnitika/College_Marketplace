import 'package:flutter/material.dart';
import 'package:marketplace/common_widgets/allProduct_list_tile.dart';
import 'package:marketplace/common_widgets/donation_list_tile.dart';
import 'package:marketplace/models/donation.dart';
import 'package:marketplace/models/user.dart';
import 'package:marketplace/sell/add_edit_product.dart';
import 'package:marketplace/common_widgets/empty_content.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';

import 'add_donations.dart';


class DonationAds extends StatelessWidget {
  DonationAds({Key key, @required this.database, this.donation})
      : super(key: key);
  final Database database;
  final DonationEvent donation;

  static Future<void> show(BuildContext context,
      {DonationEvent donation}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DonationAds(

          database: database,
         donation: donation,
        ),
        fullscreenDialog: true,
      ),
    );
  }




  Future<void> _delete(BuildContext context, DonationEvent donation) async {
    try{
      final database = Provider.of<Database>(context);
      await database.deleteDonation(donation);

    }catch(e){
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Event Deletion Failed'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });

    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _buildContents(context),
    );
  }


  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 100,
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
                  top: 50,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Donation Events",
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

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    final user = Provider.of<User>(context);
    return Column(
      children: <Widget>[
        _header(context),
        Flexible(
          child: StreamBuilder<List<DonationEvent>>(
            stream: database.allDonationsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final allDonations = snapshot.data;
                if(allDonations.isNotEmpty) {
                  final children = allDonations
                      .map((donation) => Dismissible(
                    key: Key('donation-${donation.id}'),
                    background: Container(color: Colors.red,),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) => _delete(context , donation),
                    child: DonationEventTile(
                     donation: donation,
                      onTap: () => AddEditDonation.show(context, donation: donation),
                    ),
                  ))
                      .toList();
                  return ListView(children: children);
                }
                return EmptyContent();
              }
              if (snapshot.hasError) {
                return EmptyContent(
                  title:'Something went wrong' ,
                  message: 'Can\'t load items right now',
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }


}
