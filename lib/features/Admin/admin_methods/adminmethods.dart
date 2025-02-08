import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void changeOrderStatus(String uid, String orderId, String currentStatus) {
    try {
      _firestore.collection('orders').doc(orderId).update({
        'orderStatus': currentStatus,
      });

      _firestore
          .collection('users')
          .doc(uid)
          .collection('orders')
          .doc(orderId)
          .update({
        'orderStatus': currentStatus,
      });
      // ignore: avoid_print
      print('success to update order status');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to update order status: $e');
    }
  }
}
