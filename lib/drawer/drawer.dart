import 'package:flutter/material.dart';
import 'package:marketplace/drawer/about.dart';
import 'package:marketplace/theme/color.dart';


class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {



    return Container(
      width: 280.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [LightColor.darkBlue, LightColor.brighter])),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: new BoxDecoration(color: Colors.grey[200]),
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
            onTap: () {

            },
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

            },
          ),
        ],
      ),
    );
  }
}
