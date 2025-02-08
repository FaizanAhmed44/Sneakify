import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final List<Map<String, String>> address;
  final String age;
  final int selectedAddressIndex;
  final String uid;
  final String email;
  final String username;
  final String phoneNumber;
  final String profileUrl;
  final String accountType;

  UserModel({
    required this.age,
    required this.uid,
    required this.address,
    required this.selectedAddressIndex,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.profileUrl,
    required this.accountType,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "age": age,
        "uid": uid,
        "address": address,
        "userName": username,
        "selectedAddressIndex": selectedAddressIndex,
        "phoneNumber": phoneNumber,
        "profileUrl": profileUrl,
        "accountType": accountType,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      age: snapshot['age'],
      uid: snapshot['uid'],
      selectedAddressIndex: snapshot['selectedAddressIndex'],
      address: List<Map<String, String>>.from(
          snapshot['address'].map((item) => Map<String, String>.from(item))),
      email: snapshot['email'],
      username: snapshot['username'],
      phoneNumber: snapshot['phoneNumber'],
      profileUrl: snapshot['profileUrl'],
      accountType: snapshot['accountType'],
    );
  }
}
