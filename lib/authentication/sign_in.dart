import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/administration/admin.dart';

import 'package:marketplace/authentication/create_account.dart';
import 'package:marketplace/authentication/email_sign_in.dart';
import 'package:marketplace/common_widgets/custom_raised_button.dart';
import 'package:marketplace/common_widgets/sign_in_button.dart';
import 'package:marketplace/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  TextEditingController adminController = TextEditingController();

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signInAnonymously();
    } catch (e) {
      print('${e.toString()}');
    }
  }



  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => EmailSignIn(),
      fullscreenDialog: true,
    ));
  }

  void _createAccount(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => CreateAccount(),
      fullscreenDialog: true,
    ));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text('College Marketplace'),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(
            height: 48.0,
          ),

          SignInButton(
            text: 'Admin Sign In',
            textColor: Colors.white,
            color: Colors.indigo[300],
            onPressed: () {
              _signInWithEmail(context);
            },

          ), SizedBox(
            height: 8.0,
          ),

          CustomRaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  'assets/google.png',
                  height: 30,
                  width: 30,
                ),
                Text(
                  'Sign in with Google',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15.0,
                  ),
                ),
                Opacity(
                    opacity: 0.0,
                    child: Image.asset(
                      'assets/google.png',
                      height: 30,
                      width: 30,
                    )),
              ],
            ),
            color: Colors.white,
            onPressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal[800],
            onPressed: () {
              _signInWithEmail(context);
            },
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Go Anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: () => _signInAnonymously(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Create Account',
            textColor: Colors.white,
            color: Colors.indigo[300],
            onPressed: () {
              _createAccount(context);
            },

          ),
        ],
      ),
    );
  }
}
