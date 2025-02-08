import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FavouriteMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveProduct(
      String productId, String uid, String name, String postImage) async {
    try {
      String saveId = const Uuid().v1();

      QuerySnapshot<Map<String, dynamic>>? snap;
      snap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved')
          .where(
            'productId',
            isEqualTo: productId,
          )
          .get();
      if (snap.docs.isNotEmpty) {
        if (snap.docs[0]['productId'] == productId) {
          _firestore
              .collection('users')
              .doc(uid)
              .collection('saved')
              .doc(snap.docs[0]['savedId'])
              .delete();
        }
      } else {
        _firestore
            .collection('users')
            .doc(uid)
            .collection("saved")
            .doc(saveId)
            .set({
          'productId': productId,
          'uid': uid,
          'productName': name,
          'savedId': saveId,
          'postImage': postImage,
        });
      }
    } catch (e) {
      // print(e.toString());
    }
  }
}
