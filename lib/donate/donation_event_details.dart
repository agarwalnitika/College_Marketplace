import 'package:flutter/material.dart';
import 'package:marketplace/models/donation.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';

class Donation_Event_Details extends StatefulWidget {
  Donation_Event_Details({Key key, this.database, @required this.donation})
      : super(key: key);
  final Database database;
  final DonationEvent donation;

  static Future<void> show(BuildContext context,
      {DonationEvent donation}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Donation_Event_Details(
         donation: donation,
        ),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  _Donation_Event_DetailsState createState() => _Donation_Event_DetailsState();
}

class _Donation_Event_DetailsState extends State<Donation_Event_Details> {
  String _name;
  String _date;
  String _description;
  String _owner;
  int _contact;



  @override
  void initState() {
    super.initState();
    if (widget.donation != null) {
      _name = widget.donation.name;
      _date = widget.donation.date;
      _description = widget.donation.description;
      _owner = widget.donation.owner;
      _contact = widget.donation.contact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          _header(context),
          Container(
            height: 200,
            color: Colors.black,
            child: GridTile(
              child: Image.network("https://dz01iyojmxk8t.cloudfront.net/wp-content/uploads/2020/02/09110934/2D2BB9BC-42E2-4DC1-B7C8-AB2F447404DA.jpeg"),


            ),
          ),
          Container(
            child: ListTile(
              title: Center(
                  child: Text(
                    _name,
                    style: TextStyle(fontSize: 30),
                  )),
            ),
          ),
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '      Date:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    _date,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '      Description:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    ' $_description',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '      Owner:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    _owner,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    '      Contact:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                   '$_contact',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }


  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 70,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.brighter,
          ),
          child: Stack(
            fit: StackFit.expand,

            children: <Widget>[

              Positioned(
                top: 40,
                left: 50,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                  onPressed: null,
                ),
              ),
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
                  top: 15,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top:9.0),
                                child: Text(
                                  "Event Details",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
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


}
