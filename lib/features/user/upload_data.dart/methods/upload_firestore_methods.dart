import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/Admin/upload_data.dart/methods/storagemethods.dart';
import 'package:ecommerce_app/features/Admin/upload_data.dart/model/postmodel.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadProduct(
    String description,
    String productName,
    double price,
    double discPrice,
    List<Uint8List> file,
    String stock,
    String category,
    String brandName,
    String gender,
    List<int> size,
  ) async {
    String res = 'some error occurred';
    try {
      List<String> photoUrl =
          await StorageMethod().uploadImageToStorage(file, "productImages");

      String productId = const Uuid().v1();

      ProductModel shoes = ProductModel(
        datePublished: DateTime.now(),
        price: price,
        discPrice: discPrice,
        description: description,
        productName: productName,
        productId: productId,
        productNameLowercase: productName.toLowerCase(),
        pictureUrl: photoUrl,
        gender: gender,
        brandName: brandName,
        stock: stock,
        category: category,
        size: size,
        averageRating: 0.0,
        review: [],
      );

      await _firestore
          .collection("AllProducts")
          .doc(productId)
          .set(shoes.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
