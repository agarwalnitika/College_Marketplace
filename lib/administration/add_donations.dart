import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/models/donation.dart';
import 'package:marketplace/services/database.dart';
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


  @override
  void initState() {
    super.initState();
    if (widget.donation != null) {
      _name = widget.donation.name;
      _date = widget.donation.date;
      _description = widget.donation.description;
      _owner = widget.donation.owner;
      _contact = widget.donation.contact;

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
        final id = widget.donation?.id ?? documentIdFromCurrentDate();
        final donation = DonationEvent(
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
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        title: Text(widget.donation == null ? 'New Donation Event' : 'Edit Event'),
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
