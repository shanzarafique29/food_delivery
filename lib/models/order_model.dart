import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price; 
  final double originalPrice; 
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.originalPrice = 0.0,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: (data['originalPrice'] ?? data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
    };
  }
}

class OrderModel {
  final String? id;
  final String userId;
  final String userName;
  final String userPhone;
  final String userAddress;
  final double totalAmount;
  final double discountAmount; 
  final String? appliedOfferCode; 
  final String deliveryOption;
  final String paymentMethod;
  final DateTime createdAt;
  final String status;
  final List<OrderItem> items;

  OrderModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.totalAmount,
    this.discountAmount = 0.0,
    this.appliedOfferCode,
    required this.deliveryOption,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
    this.status = "pending",
  });

  factory OrderModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      userAddress: data['userAddress'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      discountAmount: (data['discountAmount'] ?? 0).toDouble(),
      appliedOfferCode: data['appliedOfferCode'],
      deliveryOption: data['deliveryOption'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'pending',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'appliedOfferCode': appliedOfferCode,
      'deliveryOption': deliveryOption,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}