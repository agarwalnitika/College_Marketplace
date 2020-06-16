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
        child: ListTile(
          title: Text(
            category.name,
            style: TextStyle(fontSize: 20),
          ),

          onTap: () => AddCategory.show(context, category: category),
        ),
      ),
    );
  }
}
