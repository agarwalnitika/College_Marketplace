import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/services/storage_service.dart';
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
  String _uploadedFileURL;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product.name;
      _price = widget.product.price;
      _description = widget.product.description;
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
        final auth = Provider.of<StorageService>(context);
        await auth.uploadFile();


        final product = SingleProduct(
            id: id, name: _name, price: _price, description: _description);
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
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        title: Text(widget.product == null ? 'New Product' : 'Edit Product'),
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
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
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
      Container(
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
      ),
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
}
