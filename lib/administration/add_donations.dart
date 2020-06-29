import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/models/donation.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';

class AddEditDonation extends StatefulWidget {
  AddEditDonation({Key key, @required this.database, this.donation})
      : super(key: key);
  final Database database;
  final DonationEvent donation;


  static Future<void> show(BuildContext context,
      {DonationEvent donation}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditDonation(
          database: database,
          donation: donation,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddEditDonationState createState() => _AddEditDonationState();
}

class _AddEditDonationState extends State<AddEditDonation> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _date;
  String _description;
  String _owner;
  int _contact;
  File _image;
  String _imageString;
  String _uploadedFileURL;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    if (widget.donation != null) {
      _name = widget.donation.name;
      _date = widget.donation.date;
      _description = widget.donation.description;
      _owner = widget.donation.owner;
      _contact = widget.donation.contact;
      _imageString = widget.donation.imageUrl;

    }
  }


  Future<void> chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }



  Future uploadingImages() async {

    final StorageReference mStorageRef = FirebaseStorage.instance
        .ref()
        .child('donations/${widget.donation?.id ?? _owner}/${DateTime.now()}.png');
        final StorageUploadTask uploadTask = mStorageRef.putFile(_image);
        setState(() {
          progress = 1;
        });
        final StorageTaskSnapshot uploadComplete = await uploadTask.onComplete;
        _uploadedFileURL= await mStorageRef.getDownloadURL();
        setState(() {
          _uploadedFileURL  = _uploadedFileURL as String;
          progress = 0;
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

        if (_image!= null) await uploadingImages();
        final id = widget.donation?.id ?? documentIdFromCurrentDate();
        final donation = DonationEvent(
            imageUrl: _uploadedFileURL == null ? _imageString : _uploadedFileURL,
          id: id, name: _name, date: _date, description: _description , owner: _owner, contact: _contact);
        await widget.database.create_edit_Donation(donation );
        Navigator.of(context).pop();
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Event Creation Failed'),
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
                                   widget.donation == null ? 'New Event' : 'Edit Event',
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
    final screensize = MediaQuery.of(context).size;
    return [
      Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (progress == 0)
                ?() { chooseFile();}: (){
              CircularProgressIndicator();
            } ,
            child: Container(
                height: 245.0,
                width: screensize.width,
                child: new DecoratedBox(decoration:new BoxDecoration(
                    borderRadius: BorderRadius.circular(10) ,
                    border:  Border.all(color: Colors.grey[600]),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image:_image != null
                        ? FileImage(_image)
                        : CachedNetworkImageProvider(
                      _imageString == null
                          ? 'https://imageog.flaticon.com/icons/png/512/117/117885.png?size=1200x630f&pad=10,10,10,10&ext=png&bg=FFFFFFFF'
                          : _imageString,

                    ),
                    ) ),)
            ),
          ),
        ),
      ),
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Event Name'),
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        initialValue: _date != null ? '$_date' : null,
        decoration: InputDecoration(labelText: 'Event Date'),
        onSaved: (value) => _date = value,
        validator: (value) => value.isNotEmpty ? null : 'Date can\'t be empty',
        keyboardType: TextInputType.number,
      ),
      TextFormField(
        initialValue: _description,
        decoration: InputDecoration(labelText: 'Event Description'),
        onSaved: (value) => _description = value,
        validator: (value) =>
        value.isNotEmpty ? null : 'Description can\'t be empty',
      ),
      TextFormField(
        initialValue: _owner,
        decoration: InputDecoration(labelText: 'Event Owner'),
        onSaved: (value) => _owner = value,
        validator: (value) =>
        value.isNotEmpty ? null : 'Owner name can\'t be empty',
      ),
      TextFormField(
        initialValue:  _contact != null ? '$_contact' : null,
        decoration: InputDecoration(labelText: 'Event Contact'),
        onSaved: (value) => _contact = int.tryParse(value) ?? 0,
        validator: (value) =>
        value.isNotEmpty ? null : 'Contact can\'t be empty',
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



