import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData(
      {@required String path1, String path2, Map<String, dynamic> data}) async {

    final reference1 = Firestore.instance.document(path1);
    final reference2 = Firestore.instance.document(path2);
    await reference1.setData(data);
    await reference2.setData(data);
  }

  Future<void> deleteData(
      {@required String path1, String path2,}) async {
    final reference1 = Firestore.instance.document(path1);
    final reference2 = Firestore.instance.document(path2);

    await reference1.delete();
    await reference2.delete();
  }


  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data , String documentID),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => builder(snapshot.data , snapshot.documentID),
        )
        .toList());
  }
}
