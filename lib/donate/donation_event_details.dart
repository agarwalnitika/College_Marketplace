import 'package:flutter/material.dart';
import 'package:marketplace/models/donation.dart';
import 'package:marketplace/services/database.dart';

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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Event Name'),
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.black,
            child: GridTile(
              child: Container(
                color: Colors.white,
              ),
              footer: Text(_name),
            ),
          ),
          Container(
            child: ListTile(
              title: Center(
                  child: Text(
                    _name,
                    style: TextStyle(fontSize: 40),
                  )),
            ),
          ),
          Divider(),

          Row(
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
}
