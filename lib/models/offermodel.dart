import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String id;
  final String title;
  final String code;
  final double discountPercent;
  final String? productId;
  final String? categoryId;
  final double minOrderAmount;
  final bool requiresCode;
  final bool isActive;
  final bool isFeatured;
  final String? description;
  final String? imageUrl; 
  final DateTime? expiryDate;

  OfferModel({
    required this.id,
    required this.title,
    required this.code,
    required this.discountPercent,
    this.productId,
    this.categoryId,
    this.minOrderAmount = 0,
    this.requiresCode = false,
    required this.isActive,
    this.isFeatured = false,
    this.description,
    this.imageUrl,
    this.expiryDate,
  });

  factory OfferModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OfferModel(
      id: doc.id,
      title: data['title'] ?? '',
      code: data['code'] ?? '',
      discountPercent: (data['discountPercent'] as num?)?.toDouble() ?? 0.0,
      productId: data['productId'],
      categoryId: data['categoryId'],
      minOrderAmount: (data['minOrderAmount'] as num?)?.toDouble() ?? 0.0,
      requiresCode: data['requiresCode'] == true,
      isActive: data['isActive'] ?? true,
      isFeatured: data['isFeatured'] == true,
      description: data['description'],
      imageUrl: data['imageUrl'],
      expiryDate: (data['expiryDate'] is Timestamp) ? (data['expiryDate'] as Timestamp).toDate() : null,
    );
  }
}