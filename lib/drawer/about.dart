import 'package:flutter/material.dart';


class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {

          },
        ),
        title: Center(child: Text("About Us")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                    ' A peer-to-peer online marketplace for college students to stay connected and '' promote collaborative consumption.'
                    'students to buy, sell, trade amongst'
                   ' themselves, with convenience and safety as they can meet each other on campus' , style: TextStyle(
                  fontSize: 18,
                ),),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text('"Save money on the stuff you want. Make money off the stuff you don\'t."',style: TextStyle(
    fontSize: 24,color: Colors.indigo),),
            ),
          ],
        ),
      ),
    );
  }
}
