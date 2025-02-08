import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/user/order/model/ordermodel.dart';

class OrderMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toJson());

      await _firestore
          .collection('users')
          .doc(order.userId)
          .collection('orders')
          .doc(order.orderId)
          .set({
        'orderId': order.orderId,
        'orderDate': order.orderDate,
        'totalAmount': order.totalAmount,
        'orderStatus': order.orderStatus,
        'productDetail': order.products,
      });
      // return 'Order placed successfully';
    } catch (e) {
      // return 'Failed to place order: $e';
    }
  }
}
