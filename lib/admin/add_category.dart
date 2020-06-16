import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


class CategoryService {
  String ref = "categories";
  Firestore _firestore = Firestore.instance;
  void createCategory(String name) {
    var cid = new Uuid();
    String categoryId = cid.v4();
    _firestore.collection('categories').document(categoryId).setData({"category":name});
  }

  Future<List<DocumentSnapshot>> getCategoriesList() {
    return _firestore.collection(ref).getDocuments().then((snaps) {
      return snaps.documents;
    });
  }

}
