import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/common_widgets/avatar.dart';
import 'package:marketplace/common_widgets/empty_content.dart';
import 'package:marketplace/models/user.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/theme/color.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

class MyAccount extends StatefulWidget {


  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  File _image;
  String _uploadedFileURL;

  Future<void> chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future<void> _signOut(BuildContext context) async {

    final auth = Provider.of<AuthBase>(context);
    try {
      await auth.signOut();

    } catch (e) {
      print('${e.toString()}');
    }
  }

  Future<void> uploadFile() async {
    final auth = Provider.of<AuthBase>(context);
    await auth.uploadImage(_image.path);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(

      body: Stack(
        children: <Widget>[
          _header(context),
          Column(
            children: <Widget>[
              SizedBox(
                height: 60,
              ),

              Container(
                height: 600,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('users')
                              .document(user.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            var userDocument = snapshot.data;
                            print(userDocument);
                            return ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: 100,
                                ),
                                checkUser(userDocument , user),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () => _signOut(context),
              ),
            ),
          ),

        ],
      ),
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
                  top: 40,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "My Account",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ))),
              Positioned(
                bottom: 200,
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

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: _image == null ? chooseFile : uploadFile,
          child: Container(
            child: Avatar(
              photoUrl: _image != null ? _uploadedFileURL : user.photoUrl,
              radius: 50,
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        if (user.name != null)
          Text(
            user.name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  checkUser(DocumentSnapshot userDocument,User user) {
    if (userDocument['email'] == null) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          _buildUserInfo(user),
          Container(
            height: 100,
            child: Center(
              child: EmptyContent(
                title: "No Account Found :(",
                message: 'Register yourself to get started',
              ),
            ),
          ),
        ],
      );
    } else if  (userDocument['name'] == null) {


      return Column(
        children: <Widget>[
          _buildUserInfo(user),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [LightColor.brighter, LightColor.darkBlue])),
            child: ListTile(
              onTap: () {},
              title: Center(
                  child: Text(
                    "Nitika Agarwal",
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ),
          Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Colors.teal,
                ),
                title: Text(
                  userDocument["phone"],
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontFamily: 'Source Sans Pro',
                    fontSize: 20.0,
                  ),
                ),
              )),

          Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.teal,
                ),
                title: Text(
                  userDocument["email"],
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.teal.shade900,
                      fontFamily: 'Source Sans Pro'),
                ),
              ))
        ],
      );

    }else {
      return Column(
        children: <Widget>[
          _buildUserInfo(user),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [LightColor.brighter, LightColor.darkBlue])),
            child: ListTile(
              onTap: () {},
              title: Center(
                  child: Text(
                userDocument["name"],
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              )),
            ),
          ),
          Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Colors.teal,
                ),
                title: Text(
                  userDocument["phone"],
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontFamily: 'Source Sans Pro',
                    fontSize: 20.0,
                  ),
                ),
              )),

          Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.teal,
                ),
                title: Text(
                  userDocument["email"],
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.teal.shade900,
                      fontFamily: 'Source Sans Pro'),
                ),
              ))
        ],
      );
    }
  }
}

