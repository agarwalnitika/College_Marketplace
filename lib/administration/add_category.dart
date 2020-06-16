import 'package:flutter/material.dart';
import 'package:marketplace/models/category.dart';
import 'package:marketplace/services/database.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  AddCategory({Key key, @required this.database, this.category})
      : super(key: key);
  final Database database;
  final Category category;

  static Future<void> show(BuildContext context,
      {Category category}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCategory(
          database: database,
          category: category,
        ),
        fullscreenDialog: true,
      ),
    );
  }


  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  String _name;


  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final id = widget.category?.id ?? documentIdFromCurrentDate();

        print(id);
        final category = Category(
            id: id, name: _name,);
        await widget.database.addCategory(category);
        Navigator.of(context).pop();
      }
      catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Product Creation Failed'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      centerTitle: true,
      title: Text('Add Category'),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Save',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          onPressed: _submit,
        )
      ],
    ),
    backgroundColor: Colors.grey[200],
    body: _buildContents(),);
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );

  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }


  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Category Name'),
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),

    ];
  }


}
