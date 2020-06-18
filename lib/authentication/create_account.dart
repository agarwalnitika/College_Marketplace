import 'package:flutter/material.dart';
import 'package:marketplace/authentication/validators.dart';
import 'package:marketplace/common_widgets/form_submit_button.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
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
                                "Create Account",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            ))
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


class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _header(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: AccountForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountForm extends StatefulWidget with SignUpValidator {
  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String get _name => _nameController.text;
  String get _phone => _phoneController.text;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  void _nameEditingComplete() {
    final newFocus =
        widget.nameValidator.isValid(_name) ? _phoneFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _phoneEditingComplete() {
    final newFocus = widget.phoneValidator.isValid(_phone)
        ? _emailFocusNode
        : _phoneFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  _updateState() {
    setState(() {});
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.createUserWithEmail(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _phoneController.text);
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Account Creation Failed'),
              content: Text(e.message),
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
    } finally {
      setState(() {
        _isLoading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    bool submitEnabled = widget.nameValidator.isValid(_name) &&
        widget.phoneValidator.isValid(_phone) &&
        widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    return [
      _nameTextField(),
      SizedBox(
        height: 8,
      ),
      _phoneTextField(),
      SizedBox(
        height: 8,
      ),
      _emailTextField(),
      SizedBox(
        height: 8,
      ),
      _passwordTextField(),
      SizedBox(
        height: 8,
      ),
      Container(
        color: Colors.grey,
        child: FormSubmitButton(
          text: 'Create Account',
          onPressed: submitEnabled ? _submit : null,
        ),
      )
    ];
  }

  TextField _nameTextField() {
    bool showErrorText = _submitted && !widget.nameValidator.isValid(_name);
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Nitika Agarwal',
        errorText: showErrorText ? widget.invalidNameErrorText : null,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      onEditingComplete: _nameEditingComplete,
      onChanged: (name) => _updateState(),
      enabled: _isLoading == false,
    );
  }

  TextField _phoneTextField() {
    bool showErrorText = _submitted && !widget.phoneValidator.isValid(_phone);
    return TextField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '9876543210',
        errorText: showErrorText ? widget.invalidPhoneErrorText : null,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      focusNode: _phoneFocusNode,
      onEditingComplete: _phoneEditingComplete,
      onChanged: (phone) => _updateState(),
      enabled: _isLoading == false,
    );
  }

  TextField _emailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
      enabled: _isLoading == false,
    );
  }

  TextField _passwordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '*****',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
      enabled: _isLoading == false,
    );
  }
}
