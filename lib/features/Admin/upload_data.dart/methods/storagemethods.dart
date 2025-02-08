import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> uploadImageToStorage(
      List<Uint8List> file, String childName) async {
    String id = const Uuid().v1();
    String id1 = const Uuid().v1(); // Move this outside the loop

    // Set up a single folder for each product's images
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid).child(id);

    List<String> downloadUrl = [];

    for (int i = 0; i < file.length; i++) {
      // Upload each image to the same folder
      UploadTask task = ref.child('$id1-$i').putData(file[i]);
      TaskSnapshot snap = await task;
      String a = await snap.ref.getDownloadURL();
      downloadUrl.add(a);
    }

    return downloadUrl;
  }
}

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(Uint8List file, String childName) async {
    // first  child is for the folder name like profile,post etc and seconf child is for user folder which contain userId we make seperate folder for each user
    Reference ref = _storage.ref().child(childName).child(const Uuid().v1());

    //upload data
    UploadTask task = ref.putData(file);

    TaskSnapshot snap = await task;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
