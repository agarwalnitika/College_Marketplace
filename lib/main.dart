import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/landing_page.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/splash_screen.dart';
import 'package:marketplace/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Provider<AuthBase>(
      builder: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "College Marketplace",
        theme: AppTheme.lightTheme,
        home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/landingpage': (BuildContext context) => LandingPage(),

          } ));



  }
}
