import 'package:flutter/material.dart';
import 'package:marketplace/landing_page.dart';
import 'package:marketplace/services/auth.dart';
import 'package:provider/provider.dart';

import 'authentication/sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      builder: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "College Marketplace",
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
