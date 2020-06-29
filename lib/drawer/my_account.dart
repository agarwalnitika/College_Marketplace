import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
  int progress = 0;
  var id;
  var _imageString;

  Future<void> chooseFile(User user) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
    addImage(user);
  }

  Future uploadingImages() async {
    final StorageReference mStorageRef = FirebaseStorage.instance
        .ref()
        .child('images/$id/${DateTime.now()}.png');
    final StorageUploadTask uploadTask = mStorageRef.putFile(_image);
    setState(() {
      progress = 1;
    });
    final StorageTaskSnapshot uploadComplete = await uploadTask.onComplete;
    _uploadedFileURL = await mStorageRef.getDownloadURL();
    setState(() {
      _uploadedFileURL = _uploadedFileURL as String;
      progress = 0;
    });
  }

  void addImage(User user) async {
    if (_image != null) await uploadingImages();
    print('uploaded image');
    Firestore.instance.collection('users').document(user.uid).updateData({
      'photoUrl': _uploadedFileURL ,
    });
    print('uploadedggimage');
  }

  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context);
    try {
      await auth.signOut();
    } catch (e) {
      print('${e.toString()}');
    }
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
                            id = user.uid;
                            _imageString = userDocument['photoUrl'];
                            return ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: 100,
                                ),
                                checkUser(userDocument, user),
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
                          /*IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),*/
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

  Widget _buildUserImage(
      DocumentSnapshot userDocument, User user, BuildContext context) {
    return GestureDetector(
      onTap: (progress == 0)
          ? () {
              chooseFile(user);
            }
          : () {},
      child: Container(
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.black12,
          backgroundImage: _image != null
              ? FileImage(_image)
              : CachedNetworkImageProvider(
                  userDocument['photoUrl'] == null
                      ? 'data:image/png;base64,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'
                      : _imageString,
                ),
        ),
      ),
    );
  }

  checkUser(DocumentSnapshot userDocument, User user) {
    if (userDocument['email'] == null) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 160,
          ),
          Container(
            height: 100,
            child: Center(
              child: EmptyContent(
                color: Colors.grey[300],
                title: "No Account Found :(",
                message: 'Register yourself to get started',
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          _buildUserImage(userDocument, user, context),
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
