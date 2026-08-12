import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final String description;
  final String? offerId;
  final String? categoryId;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    this.offerId,
    this.categoryId,
  });

  factory ProductModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : (data['price'] is double)
              ? data['price'] as double
              : double.tryParse(data['price']?.toString() ?? '0') ?? 0.0, // ✅ safe parse
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      offerId: data['offerId'],
      categoryId: data['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price, 
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'offerId': offerId,
      'categoryId': categoryId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
