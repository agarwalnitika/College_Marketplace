import 'package:flutter/material.dart';
import 'package:marketplace/models/donation.dart';

class DonationEventTile extends StatelessWidget {
  const DonationEventTile({Key key, @required this.donation, this.onTap , this.height , this.width})
      : super(key: key);
  final double height;
  final double width;
  final DonationEvent donation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: height,
          width: width,
          child: GestureDetector(
              onTap: onTap,
              child: my_card (donation.imageUrl==null?'https://media.gettyimages.com/photos/with-children-during-his-visit-to-ngo-prerna-to-formally-take-part-in-picture-id459239430?s=612x612':donation.imageUrl, donation.name)),
        ),
      ],
    );
  }
}


Widget my_card (String my_img, String my_txt) {
  return Container(
    margin: EdgeInsets.only( top: 9.0),
    constraints: new BoxConstraints.expand(
      height: 150.0,
      width: 600,
    ),
    alignment: Alignment.center,
    decoration: new BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 0.0,
          blurRadius: 9,
          offset: Offset(0, 7), // changes position of shadow
        ),
      ],
      image: new DecorationImage(
        image: new NetworkImage(my_img),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(
      child: new Text(my_txt,
          style: new TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          )),
    ),
  );
}


