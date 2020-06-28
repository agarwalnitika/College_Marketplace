import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  File _image1;
  File _image2;
  File _image3;
  String _owner;
  int _contact;
  String _uploadedFileURL1;
  String _uploadedFileURL2;
  String _uploadedFileURL3;
  int progress = 0;
  var id;
  String _imageString1;
  String _imageString2;
  String _imageString3;


  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product.name;
      _price = widget.product.price;
      _description = widget.product.description;
      _owner = widget.product.owner;
      _contact = widget.product.contact;
      _imageString1 = widget.product.imageUrl1;
      _imageString2 = widget.product.imageUrl2;
      _imageString3 = widget.product.imageUrl3;
    }
  }

  Future<void> chooseFile( int imageNumber ) async {

    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {

      switch (imageNumber) {
        case 1:
          setState(() => _image1 = image);
          break;
        case 2:
          setState(() => _image2 = image);
          break;
        case 3:
          setState(() => _image3 = image);
          break;
      }
    });
  }

  Future uploadingImages(int imageNumber) async {

    final StorageReference mStorageRef = FirebaseStorage.instance
        .ref()
        .child('products/${widget.product?.id ?? _owner}/${DateTime.now()}.png');
    switch (imageNumber) {
      case 1:
        final StorageUploadTask uploadTask = mStorageRef.putFile(_image1);
        setState(() {
          progress = 1;
        });
        final StorageTaskSnapshot uploadComplete = await uploadTask.onComplete;
        _uploadedFileURL1 = await mStorageRef.getDownloadURL();
        setState(() {
          _uploadedFileURL1 = _uploadedFileURL1 as String;
          progress = 0;
        });
        break;
      case 2:
        final StorageUploadTask uploadTask = mStorageRef.putFile(_image2);
        setState(() {
          progress = 1;
        });
        final StorageTaskSnapshot uploadComplete = await uploadTask.onComplete;
        _uploadedFileURL2 = await mStorageRef.getDownloadURL();
        setState(() {
          _uploadedFileURL2 = _uploadedFileURL2 as String;
          progress = 0;
        });
        break;
      case 3:
        final StorageUploadTask uploadTask = mStorageRef.putFile(_image3);
        setState(() {
          progress = 1;
        });
        final StorageTaskSnapshot uploadComplete = await uploadTask.onComplete;
        _uploadedFileURL3 = await mStorageRef.getDownloadURL();
        setState(() {
          _uploadedFileURL3 = _uploadedFileURL3 as String;
          progress = 0;
        });
        break;
    }

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
        if (_image1 != null) await uploadingImages(1);
        if (_image2 != null) await uploadingImages(2);
        if (_image3 != null) await uploadingImages(3);
        final id = widget.product?.id ?? documentIdFromCurrentDate();
        final product = SingleProduct(
          imageUrl1: _uploadedFileURL1 == null ? _imageString1 : _uploadedFileURL1,
            imageUrl2: _uploadedFileURL2 == null ? _imageString2 : _uploadedFileURL2,
            imageUrl3: _uploadedFileURL3 == null ? _imageString3 : _uploadedFileURL3,
            id: id, name: _name, price: _price, description: _description ,owner: _owner,contact: _contact);
        await widget.database.create_edit_Product(product);
        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
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
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (progress == 0)
                      ?() { chooseFile(1);}: (){
                    CircularProgressIndicator();
                  } ,
                  child: Container(
                    height: 245.0,
                    width: 100.0,
                      child: new DecoratedBox(decoration:new BoxDecoration(
                          borderRadius: BorderRadius.circular(10) ,
                          border:  Border.all(color: Colors.grey[600]),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(image:_image1 != null
                              ? FileImage(_image1)
                              : CachedNetworkImageProvider(
                            _imageString1 == null
                                ? 'https://imageog.flaticon.com/icons/png/512/117/117885.png?size=1200x630f&pad=10,10,10,10&ext=png&bg=FFFFFFFF'
                                : _imageString1,
                          ),
                      ) ),)
                  ),
                  ),
                ),
              ),
          ),
          Expanded(
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (progress == 0)
                      ?() { chooseFile(2);}: (){
                    CircularProgressIndicator();
                  } ,
                  child: Container(
                      height: 245.0,
                      width: 100.0,
                      child: new DecoratedBox(decoration:new BoxDecoration(
                          borderRadius: BorderRadius.circular(10) ,
                          border:  Border.all(color: Colors.grey[600]),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(image:_image2 != null
                              ? FileImage(_image2)
                              : CachedNetworkImageProvider(
                            _imageString2 == null
                                ? 'https://imageog.flaticon.com/icons/png/512/117/117885.png?size=1200x630f&pad=10,10,10,10&ext=png&bg=FFFFFFFF'
                                : _imageString2,
                          ),
                          ) ),)
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (progress == 0)
                      ?() { chooseFile(3);}: (){
                    CircularProgressIndicator();
                  } ,
                  child: Container(
                      height: 245.0,
                      width: 100.0,
                      child: new DecoratedBox(decoration:new BoxDecoration(
                        borderRadius: BorderRadius.circular(10) ,
                          border:  Border.all(color: Colors.grey[600]),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(image:_image3 != null
                              ? FileImage(_image3)
                              : CachedNetworkImageProvider(
                            _imageString3 == null
                                ? 'https://imageog.flaticon.com/icons/png/512/117/117885.png?size=1200x630f&pad=10,10,10,10&ext=png&bg=FFFFFFFF'
                                : _imageString3,
                          ),
                          ) ),)
                  ),
                ),
              ),
            ),
          ),
        ],
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
