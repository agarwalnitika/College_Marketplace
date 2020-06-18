import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';

class AddEditProduct extends StatefulWidget {
  AddEditProduct({Key key, @required this.database, this.product})
      : super(key: key);
  final Database database;
  final SingleProduct product;

  static Future<void> show(BuildContext context,
      {SingleProduct product}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditProduct(
          database: database,
          product: product,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _price;
  String _description;
  File _image;
  String _owner;
  int _contact;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product.name;
      _price = widget.product.price;
      _description = widget.product.description;
      _owner = widget.product.owner;
      _contact = widget.product.contact;
    }
  }

  Future<void> chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

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
        final id = widget.product?.id ?? documentIdFromCurrentDate();
        final product = SingleProduct(
          imageUrl: null,
            id: id, name: _name, price: _price, description: _description ,owner: _owner,contact: _contact);
        await widget.database.create_edit_Product(product);
        Navigator.of(context).pop();
      } catch (e) {
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
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
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
     /* Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlineButton(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.7), width: 2.5),
            onPressed: chooseFile,
            child: _displayChild(),
          ),
        ),
      ),*/
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Product Name'),
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        initialValue: _price != null ? '$_price' : null,
        decoration: InputDecoration(labelText: 'Product Price'),
        onSaved: (value) => _price = int.tryParse(value) ?? 0,
        validator: (value) => value.isNotEmpty ? null : 'Price can\'t be empty',
        keyboardType: TextInputType.number,
      ),
      TextFormField(
        initialValue: _description,
        decoration: InputDecoration(labelText: 'Product Description'),
        onSaved: (value) => _description = value,
        validator: (value) =>
            value.isNotEmpty ? null : 'Description can\'t be empty',
      ),
      TextFormField(
        initialValue: _owner,
        decoration: InputDecoration(labelText: 'Owner Name'),
        onSaved: (value) => _owner = value,
        validator: (value) =>
        value.isNotEmpty ? null : 'Name can\'t be empty',
      ),
      TextFormField(
        initialValue: _contact!=null ? '$_contact' : null,
        decoration: InputDecoration(labelText: 'Contact'),
        onSaved: (value) => _contact = int.tryParse(value) ?? 0,
        validator: (value) =>
        value.isNotEmpty ? null : 'Contact can\'t be empty',
        keyboardType: TextInputType.number,
      ),
    ];
  }

  Widget _displayChild() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 70, 14, 70),
        child: Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 10, 2, 10),
        child: Image.file(
          _image,
          fit: BoxFit.fill,
          height: 200,
        ),
      );
    }
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
                                  widget.product == null ? 'New Product' : 'Edit Product',
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
                          ),
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
