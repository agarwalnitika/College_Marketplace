import 'package:flutter/material.dart';
import 'package:marketplace/services/auth.dart';
import 'package:provider/provider.dart';

import 'add_category.dart';
import 'category_list.dart';


class AdminPage extends StatelessWidget {
  TextEditingController categoryController = TextEditingController();

  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  CategoryService _categoryService = CategoryService();
  final _formkey = GlobalKey<FormState>();
  String _name;

  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context);
    try {
      await auth.signOut();
    } catch (e) {
      print('${e.toString()}');
    }
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Admin Page'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _signOut(context),
              ),
            ],
          ),
        body: ListView(
          children: <Widget>[
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add Category"),
              onTap: () {
                _categoryAlert(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category List"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategoriesList(),
                  fullscreenDialog: true,
                ));
              },
            ),


          ],
        ),

    );
  }

  void _categoryAlert(BuildContext context) {
    var alert = AlertDialog(
      key: _categoryFormKey,
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Container(
            height: 100,
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: categoryController,
                    validator: (value) {
                      if (value.isEmpty) return "Category can't be Empty";
                    },
                    decoration: InputDecoration(hintText: "Add Category"),
                  ),
                  FlatButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      if (categoryController.text != null) {
                        _categoryService.createCategory(categoryController.text);
                        categoryController.clear();
                        Navigator.of(context).pop();

                      }

                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(context: context, builder: (_) => alert);
  }

}


