import 'package:flutter/material.dart';
import 'package:marketplace/models/category.dart';
import 'package:marketplace/services/auth.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {

  static Future<void> show(BuildContext context,
      {Category category}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ForgotPassword(
        ),
        fullscreenDialog: true,
      ),
    );
  }


  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String _email;



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
        final auth = Provider.of<AuthBase>(context);
        await auth.resetPassword(_email);
        Navigator.of(context).pop();
      }
      catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Email Reset Failed'),
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
        title: Text('Forgot Email'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Reset',
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

        decoration: InputDecoration(labelText: 'Email Id'),
        validator: (value) => value.isNotEmpty ? null : 'Email can\'t be empty',
        onSaved: (value) => _email = value,
        keyboardType: TextInputType.emailAddress,
      ),

    ];
  }


}
