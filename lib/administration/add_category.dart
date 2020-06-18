import 'package:flutter/material.dart';
import 'package:marketplace/models/category.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';

class AddEditCategory extends StatefulWidget {
  AddEditCategory({Key key, @required this.database, this.category})
      : super(key: key);
  final Database database;
  final Category category;

  static Future<void> show(BuildContext context,
      {Category category}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditCategory(
          database: database,
          category: category,
        ),
        fullscreenDialog: true,
      ),
    );
  }


  @override
  _AddEditCategoryState createState() => _AddEditCategoryState();
}

class _AddEditCategoryState extends State<AddEditCategory> {
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
        await widget.database.create_edit_Category(category);
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

    backgroundColor: Colors.grey[200],
    body: _buildContents(),);
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Column(

        children: <Widget>[
          _header(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
          ),
        ],
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


  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 90,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.brighter,
          ),
          child: Stack(
            fit: StackFit.expand,

            children: <Widget>[

              Positioned(
                top: 40,
                left: 50,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                  onPressed: null,
                ),
              ),
              Positioned(
                top: 10,
                right: -120,
                child: _circularContainer(200, LightColor.lightBlue),
              ),
              Positioned(
                  top: -60,
                  left: -65,
                  child: _circularContainer(width * .5, LightColor.darkBlue)),
              Positioned(
                  top: -230,
                  right: -30,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Colors.white38)),
              Positioned(
                  top: 35,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top:9.0),
                                child: Text(
                                   'New Category',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FlatButton(
                              child: Text(
                                'Save',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              onPressed: _submit,
                            ),
                          )
                        ],
                      ))),
            ],
          )),
    );
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

}
