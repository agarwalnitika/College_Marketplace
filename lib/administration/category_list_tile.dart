import 'package:flutter/material.dart';
import 'package:marketplace/models/category.dart';


import 'add_category.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({Key key, @required this.category, this.onTap})
      : super(key: key);
  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          category.name,
          style: TextStyle(fontSize: 20),
        ),

        onTap: () => AddCategory.show(context, category: category),
      ),
    );
  }
}
