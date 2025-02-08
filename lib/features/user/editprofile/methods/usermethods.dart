import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/Admin/upload_data.dart/methods/storagemethods.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:uuid/uuid.dart';

class UserMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserImage(
      {required Uint8List file, required String uid}) async {
    try {
      String profileUrl =
          await StorageMethods().uploadImageToStorage(file, "Profilepic");

      await _firestore.collection('users').doc(uid).update({
        'profileUrl': profileUrl,
      });
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> updateUserInfo({
    required String name,
    required String phone,
    required String age,
    required String uid,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'userName': name,
        'phoneNumber': phone,
        'age': age,
      });
    } catch (e) {
      // print(e.toString());
    }
  }

  // Future<void> addNewAddressToFirestore(Map<String, String> newAddress) async {
  //   try {

  //     // Access the user's document based on UID
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({
  //       'address': FieldValue.arrayUnion([newAddress]),
  //       'selectedAddressIndex':
  //     });

  //     print("Address added successfully!");
  //   } catch (e) {
  //     print("Error adding address: $e");
  //   }
  // }

  Future<void> addAddressAndSetDefault({
    required Map<String, String> newAddress,
    required bool isDefault,
  }) async {
    try {
      // Get reference to the user's document
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      // Fetch the current address list to find the new index for the added address
      DocumentSnapshot snapshot = await userDoc.get();
      List<dynamic> currentAddresses = snapshot['address'] ?? [];
      int newIndex = currentAddresses.length; // Index for the new address

      // Prepare update data
      Map<String, dynamic> updateData = {
        'address': FieldValue.arrayUnion([newAddress]),
      };

      // If the new address is marked as default, update `selectedAddressIndex`
      if (isDefault) {
        updateData['selectedAddressIndex'] = newIndex;
      }

      // Update the user's document in Firestore
      await userDoc.update(updateData);
    } catch (e) {
      // showSnackBar("Error adding address and updating default: $e", context);
    }
  }

  Future<void> setDefaultAddress({
    required int index,
  }) async {
    try {
      // Get reference to the user's document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'selectedAddressIndex': index,
      });
    } catch (e) {
      // print("Error updating default: $e");
    }
  }

  Future<void> savePosts(
      String bookId, String uid, String name, String postImage) async {
    try {
      String saveId = const Uuid().v1();

      QuerySnapshot<Map<String, dynamic>>? snap;
      snap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved')
          .where(
            'bookId',
            isEqualTo: bookId,
          )
          .get();
      if (snap.docs.isNotEmpty) {
        if (snap.docs[0]['bookId'] == bookId) {
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
          'bookId': bookId,
          'uid': uid,
          'name': name,
          'savedId': saveId,
          'postImage': postImage,
          "datePublished": DateTime.now(),
        });
      }
    } catch (e) {
      // print(e.toString());
    }
  }
}
