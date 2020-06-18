import 'package:flutter/material.dart';
import 'package:marketplace/authentication/email_sign_in.dart';
import 'package:marketplace/screens/sell_page.dart';
import 'package:marketplace/sell/add_edit_product.dart';
import 'package:marketplace/services/database.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';
import 'add_category.dart';
import 'add_donations.dart';





class AdminPage extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  String _name;

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      child: Container(
          height: 80,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.brighter,
          ),
          child: Stack(
            fit: StackFit.expand,
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
                  top: 40,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Admin Page",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
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


  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          _header(context),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text("Add Category"),
            onTap: () => AddEditCategory.show(context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("Add Product"),
            onTap: () => AddEditProduct.show(context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("Add Donation"),
            onTap: () =>  AddEditDonation.show(context),
          ),
          Divider(),

        ],
      ),
    );
  }
}
