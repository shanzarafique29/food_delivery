import 'package:cloud_firestore/cloud_firestore.dart';
 class OfferModel {
  final String? id;
  final String title;
  final String code;
  final double discountPercent;
  final String? description;
  final String? termsAndConditions;
  final DateTime? expiryDate;
  final bool isActive;
  final bool isFeatured;
  final String? imageUrl;
  final String? productId;
  final String? categoryId; 

  OfferModel({
    this.id,
    required this.title,
    required this.code,
    required this.discountPercent,
    this.description,
    this.termsAndConditions,
    this.expiryDate,
    this.isActive = true,
    this.isFeatured = false,
    this.imageUrl,
    this.productId,
    this.categoryId,
  });

  factory OfferModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OfferModel(
      id: doc.id,
      title: data['title'] ?? '',
      code: data['code'] ?? '',
      discountPercent: (data['discountPercent'] ?? 0).toDouble(),
      description: data['description'],
      termsAndConditions: data['termsAndConditions'],
      expiryDate: (data['expiryDate'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      imageUrl: data['imageUrl'],
      productId: data['productId'],
      categoryId: data['categoryId'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'code': code,
      'discountPercent': discountPercent,
      'description': description,
      'termsAndConditions': termsAndConditions,
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'imageUrl': imageUrl,
      'productId': productId,
      'categoryId': categoryId, 
    };
  }
}
