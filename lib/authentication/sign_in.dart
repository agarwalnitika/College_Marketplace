import 'package:flutter/material.dart';
import 'package:marketplace/authentication/create_account.dart';
import 'package:marketplace/authentication/email_sign_in.dart';
import 'package:marketplace/common_widgets/custom_raised_button.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/theme/color.dart';
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

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signInWithGoogle();
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
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }


  Widget _buildContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        _header(context),
        Padding(
          padding: const EdgeInsets.only(left:20.0,right:20,top: 220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60.0,
              ),

              CustomRaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/admin.png',
                      height: 40,
                      width: 40,
                    ),
                    Text(
                      'Admin Sign In',
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
                color: Colors.grey[300],
                onPressed: () {
                  _signInWithEmail(context);
                },
              ),/*
              SizedBox(
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
                color: Colors.grey[300],
                onPressed: () {
                  _signInWithGoogle(context);
                },
              ),*/
              SizedBox(
                height: 8.0,
              ),
              CustomRaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/email.png',
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      'Sign in with Email',
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
                color: Colors.grey[300],
                onPressed: () {
                  _signInWithEmail(context);
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              CustomRaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/anonymous.png',
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      'Go Anonymous',
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
                color: Colors.grey[300],
                onPressed: () {
                  _signInAnonymously(context);
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              CustomRaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/create.png',
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      'Create Account',
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
                color: Colors.grey[300],
                onPressed: () {
                  _createAccount(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 900,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.brighter,
          ),
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
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
                  top: 80,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      ))),
              Positioned(
                bottom:200,
                left: -120,
                child: _circularContainer(200, LightColor.lightBlue),
              ),
              Positioned(
                  bottom: -60,
                  right: -65,
                  child: _circularContainer(width * .5, LightColor.darkBlue)),
              Positioned(
                  bottom: -230,
                  left: -70,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Colors.white38)),
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
