import 'package:flutter/material.dart';
import 'package:marketplace/administration/category_list.dart';
import 'package:marketplace/services/auth.dart';
import 'package:provider/provider.dart';
import 'add_category.dart';
import 'category_list.dart';





class AdminPage extends StatelessWidget {
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

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onTap: () => AddCategory.show(context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("Category List"),
            onTap: () => CategoryList.show(context),
          ),
        ],
      ),
    );
  }
}
