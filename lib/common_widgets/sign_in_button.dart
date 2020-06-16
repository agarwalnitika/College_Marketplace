import 'package:flutter/material.dart';
import 'custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton(
      {String text,
      Color color,
      Color textColor,
      double height,
      VoidCallback onPressed})
      : super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.0,
            ),
          ),
          color: color,
          borderRadius: 2.0,
          // h: height,
          onPressed: onPressed,
        );
}
