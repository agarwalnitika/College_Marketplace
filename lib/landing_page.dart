import 'package:flutter/material.dart';
import 'package:marketplace/administration/admin.dart';

import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/database.dart';
import 'package:provider/provider.dart';
import 'authentication/sign_in.dart';
import 'package:marketplace/home_page.dart';

class LandingPage extends StatelessWidget {
  TextEditingController adminController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage();
            } else if (user.uid == 'LimdE8Laj6UlYbJ4fc4TQfhPGv03') {
              return Provider<User>.value(
                value: user,
                child: Provider<Database>(
                  child: AdminPage(),
                  builder: (_) => FirestoreDatabase(uid: user.uid),
                ),
              );
            } else {
              return Provider<User>.value(
                value: user,
                child: Provider<Database>(
                  child: Home(),
                  builder: (_) => FirestoreDatabase(uid: user.uid),
                ),
              );
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
