import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewMethods {
  Future<void> addRatingAndReview({
    required String productId,
    required String userId,
    required String userName,
    required String profPictureUrl,
    required double rating,
    required String review,
  }) async {
    try {
      // Get reference to the product document in Firestore
      DocumentReference productRef =
          FirebaseFirestore.instance.collection('AllProducts').doc(productId);

      // Fetch current product data
      DocumentSnapshot productSnapshot = await productRef.get();

      // Safely handle null values
      List<dynamic> currentReviews = productSnapshot['review'] != null
          ? List.from(productSnapshot['review'])
          : [];

      // double currentAverageRating =
      //     productSnapshot['averageRating']?.toDouble() ?? 0.0;

      // Create new review data
      Map<String, dynamic> newReview = {
        "userId": userId,
        "rating": rating,
        "review": review,
        "userName": userName,
        "profPictureUrl": profPictureUrl,
        "reviewDate": Timestamp.fromDate(DateTime.now()),
      };

      // Add the new review to the list
      currentReviews.add(newReview);

      // Calculate the new average rating
      double newAverageRating = _calculateAverageRating(currentReviews);

      // Update Firestore with the new review list and average rating
      await productRef.update({
        'review': currentReviews,
        'averageRating': newAverageRating,
      });

      // print("Rating and review added successfully!");
    } catch (e) {
      // print("Error adding rating and review: $e");
    }
  }

// Helper function to calculate average rating
  double _calculateAverageRating(List<dynamic> reviews) {
    if (reviews.isEmpty) return 0.0;

    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review['rating'] ?? 0.0;
    }
    return totalRating / reviews.length;
  }
}
