import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  User(
      {@required this.photoUrl,
      @required this.displayName,
      @required this.uid});

  final String uid;
  final String photoUrl;
  final String displayName;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmail(String email, String password);
  Future<void> resetPassword(String email);
  Future<User> createUserWithEmail(
      String email, String password, String name, String phone);
  Future<void> uploadImage(String imagePath);
  Future<DocumentSnapshot> getData();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestoreAuth = Firestore.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
        uid: user.uid, displayName: user.displayName, photoUrl: user.photoUrl);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    var firebaseUser = await _firebaseAuth.currentUser();
    _firestoreAuth.collection("users").document(firebaseUser.uid).setData({
      "image": null,
      "name": null,
      "phone": null,
      "email": null,
      "password": null,
    }).then((_) {
      print("Done");
    });
    return _userFromFirebase(authResult.user);

  }

  Future<User> signInWithEmail(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> createUserWithEmail(
      String email, String password, String name, String phone) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    var firebaseUser = await _firebaseAuth.currentUser();
    _firestoreAuth.collection("users").document(firebaseUser.uid).setData({
      "image": null,
      "name": name,
      "phone": phone,
      "email": email,
      "password": password,
    }).then((_) {
      print("Done");
    });
    return _userFromFirebase(authResult.user);
  }

  Future<void> uploadImage(String imagePath) async {
    var firebaseUser = await _firebaseAuth.currentUser();
    _firestoreAuth.collection("users").document(firebaseUser.uid).updateData({
      "image": imagePath,
    }).then((_) {
      print("Done");
    });
  }

  Future<DocumentSnapshot> getData() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    _firestoreAuth.collection("users").document(firebaseUser.uid).get().then((value){
      print(value.data.toString());
      return value.data;
    });
  }


  Future<void> retriveImage(String imagePath) async {
    var firebaseUser = await _firebaseAuth.currentUser();
    _firestoreAuth.collection("users").document(firebaseUser.uid).updateData({
      "image": imagePath,
    }).then((_) {
      print("Done");
    });
  }


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
