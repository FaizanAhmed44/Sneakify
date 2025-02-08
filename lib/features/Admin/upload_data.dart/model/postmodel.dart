import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String description;
  final double price;
  final double averageRating;
  final double discPrice;
  final String productName;
  final String productNameLowercase;
  final String productId;
  final String gender;
  final List<String> pictureUrl;
  final List<int> size;
  final List<dynamic> review;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  final String brandName;
  final String stock;
  final String category;

  ProductModel({
    required this.datePublished,
    required this.price,
    required this.averageRating,
    required this.review,
    required this.discPrice,
    required this.gender,
    required this.description,
    required this.size,
    required this.productName,
    required this.productId,
    required this.productNameLowercase,
    required this.pictureUrl,
    required this.brandName,
    required this.stock,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "price": price,
        "size": size,
        "review": review,
        "averageRating": averageRating,
        "discPrice": discPrice,
        "productNameLowercase": productNameLowercase,
        "description": description,
        "datePublished": datePublished,
        "gender": gender,
        "pictureUrl": pictureUrl,
        "brandName": brandName,
        "productId": productId,
        "stock": stock,
        "category": category,
      };

  static ProductModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ProductModel(
      gender: snapshot['gender'],
      review: snapshot['review'],
      averageRating: snapshot['averageRating'],
      price: snapshot['price'],
      discPrice: snapshot['discPrice'],
      description: snapshot['description'],
      size: snapshot['size'],
      productName: snapshot['productName'],
      datePublished: snapshot['datePublished'],
      pictureUrl: snapshot['pictureUrl'],
      brandName: snapshot['brandName'],
      stock: snapshot['stock'],
      category: snapshot['category'],
      productId: snapshot['productId'],
      productNameLowercase: snapshot['productNameLowercase'],
    );
  }
}
