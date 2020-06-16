import 'package:flutter/material.dart';
import 'package:marketplace/services/database.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);

    return Container(
      width: 280.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.lightBlue, Colors.indigo])),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: new Text(
                "Nitika Agarwal",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            decoration: new BoxDecoration(color: Colors.white),
          ),


          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            title: Text(
              'My Account',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(
              Icons.list,
              color: Colors.white,
            ),
            title: Text(
              'Category',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            title: Text(
              'Favourite',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.contacts,
              color: Colors.white,
            ),
            title: Text(
              'Contact Us',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.white,
            ),
            title: Text(
              'About Us',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(
              Icons.comment,
              color: Colors.white,
            ),
            title: Text(
              'Feedback',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);

            },
          ),
        ],
      ),
    );
  }
}
