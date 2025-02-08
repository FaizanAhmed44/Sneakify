class OrderModel {
  final String orderId;
  final String userId;
  final List<Map<String, dynamic>> products; // Each product has its own details
  final double totalAmount;
  final String orderStatus;
  final String paymentStatus;
  final String paymentMethod;
  final String shippingAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final double shippingFee;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.products,
    required this.totalAmount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.orderDate,
    this.deliveryDate,
    required this.shippingFee,
  });

  // Convert Order object to JSON (Map) format for Firebase
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'products': products,
      'totalAmount': totalAmount,
      'orderStatus': orderStatus,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'shippingFee': shippingFee,
    };
  }
}
