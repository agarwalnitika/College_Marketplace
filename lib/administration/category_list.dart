import 'package:flutter/material.dart';
import 'package:marketplace/common_widgets/empty_content.dart';
import 'package:marketplace/models/category.dart';
import 'package:marketplace/services/database.dart';
import 'package:provider/provider.dart';
import 'package:marketplace/common_widgets/category_list_tile.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key key, @required this.database, this.category})
      : super(key: key);
  final Database database;
  final Category category;

  static Future<void> show(BuildContext context,
      {Category category}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryList(
          database: database,
          category: category,

        ),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override

  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Category List'),
        actions: <Widget>[],
      ),
      body:  StreamBuilder<List<Category>>(
        stream: database.allCategoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allCategories = snapshot.data;
            if (allCategories.isNotEmpty) {
              final children = allCategories
                  .map((category) => CategoryTile(
                category: category,

              ))
                  .toList();
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: children,
              );
            }
            return EmptyContent();
          }
          if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),

    );
  }
}
