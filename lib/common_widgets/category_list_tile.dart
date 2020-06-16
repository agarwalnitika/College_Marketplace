import 'package:flutter/material.dart';
import 'package:marketplace/administration/add_category.dart';
import 'package:marketplace/models/category.dart';



class CategoryTile extends StatelessWidget {
  const CategoryTile({Key key, @required this.category})
      : super(key: key);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 130,
      child: Card(
        child: Column(
          children: <Widget>[
         ListTile(
        onTap: null,
          title: Image.asset('assets/ticket.webp',
            width: 100,
            height: 80,),
          subtitle: Text(
            category.name,textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),),

          ],
        ),
      ),
    );
  }
}
