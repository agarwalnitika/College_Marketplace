import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/common_widgets/avatar.dart';
import 'package:marketplace/services/auth.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Account'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _signOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(user),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            var userDocument = snapshot.data;
            print(user.uid);
            return  ListView(
              children: <Widget>[
                SizedBox(height: 100,),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.lightBlue, Colors.indigo])),
                  child: ListTile(
                    onTap: (){},
                    title: Center(child: Text(userDocument["name"], style: TextStyle(fontSize: 25,color: Colors.white),)),
                  ),
                ), ListTile(
                  title: Center(child: Text(userDocument["phone"], style: TextStyle(fontSize: 2),)),
                ),


                Text(userDocument['name']),
              ],
            );
          }),
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
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}