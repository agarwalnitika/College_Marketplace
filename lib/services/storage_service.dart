import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path ;

class StorageService {




  Future<void> uploadFile({File image}) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${Path.basename(image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
  }
}
