import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'add_category.dart';

class CategoriesList extends StatefulWidget {
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  CategoryService _categoryService = CategoryService();
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
  <DropdownMenuItem<String>>[];
  String _currentCategory;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _currentCategory;

    _getCategories();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();

    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['category']),
              value: categories[i].data['category'],
            ));
      });
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Color(0xFF03256C),
        title: Text('Categories'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]['category']),
                );
              },
              itemCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategoriesList();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data['category'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }
}
