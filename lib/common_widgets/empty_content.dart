import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.message = 'Add a product to get started',
    this.title = 'Nothing Here',
  }) : super(key: key);
  final String message;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
         margin: EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 3,),
            Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
