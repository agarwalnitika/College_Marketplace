import 'package:flutter/material.dart';
import 'package:marketplace/models/category.dart';



class CategoryTile extends StatelessWidget {
  const CategoryTile({Key key, @required this.category})
      : super(key: key);
  final Category category;




  @override
  Widget build(BuildContext context) {

    return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

         ListTile(
        onTap: null,
          leading: Image.asset('assets/ticket.webp',
            width: 100,
            height: 80,),
          title: Text(
            category.name,textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
           trailing: Icon(Icons.arrow_forward_ios),),

          ],
        ),
      ),
    );
  }
}
