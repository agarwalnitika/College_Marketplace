import 'package:flutter/material.dart';
import 'package:marketplace/administration/add_category.dart';
import 'package:marketplace/authentication/forgot_password.dart';
import 'package:marketplace/authentication/validators.dart';
import 'package:marketplace/common_widgets/form_submit_button.dart';
import 'package:marketplace/services/auth.dart';
import 'package:provider/provider.dart';

class EmailSignIn extends StatefulWidget {
  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text('Sign In'),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: EmailForm(),
          ),
        ),
      ),
    );
  }
}

class EmailForm extends StatefulWidget with SignInValidator {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
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
      await auth.signInWithEmail(_email, _password);
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sign In Failed'),
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
      _emailController.clear();
      _passwordController.clear();
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
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    return [
      _emailTextField(),
      SizedBox(
        height: 8,
      ),
      _passwordTextFiled(),
      SizedBox(
        height: 8,
      ),
      FormSubmitButton(
        text: 'Sign In',
        onPressed: submitEnabled ? _submit : null,
      ),
      FlatButton(
        onPressed: () => ForgotPassword.show(context),
        child: Text(
          'Forgot Password?',
          style: TextStyle(
              color: Colors.black54,
              decoration: TextDecoration.underline,
              decorationColor: Colors.black54,
              fontSize: 15),
        ),
      ),
    ];
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

  TextField _passwordTextFiled() {
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
      onChanged: (password) => _updateState(),
      enabled: _isLoading == false,
      onEditingComplete: _submit,
    );
  }
}
