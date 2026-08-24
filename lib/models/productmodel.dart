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
  final String? deliveryInfo;
  final String? termsPolicy;
  final bool isFreeDelivery;
  final String? freeDeliveryNotice;
  final double deliveryFee;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    this.offerId,
    this.categoryId,
    this.deliveryInfo,
    this.termsPolicy,
    this.isFreeDelivery = false,
    this.freeDeliveryNotice,
    this.deliveryFee = 0.0,
  });

  factory ProductModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      price: _parseDouble(data['price']),
      imageUrl: data['imageUrl']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      offerId: data['offerId']?.toString(),
      categoryId: data['categoryId']?.toString(),
      deliveryInfo: data['deliveryInfo']?.toString() ?? '',
      termsPolicy: data['termsPolicy']?.toString() ?? '',
      isFreeDelivery: data['isFreeDelivery'] == true,
      freeDeliveryNotice:
          data['freeDeliveryNotice']?.toString() ?? '',
      deliveryFee: _parseDouble(data['deliveryFee']),
    );
  }

  factory ProductModel.fromMap(
    Map<String, dynamic> data, [
    String? docId,
  ]) {
    return ProductModel(
      id: docId ?? data['id']?.toString(),
      name: data['name']?.toString() ?? '',
      price: _parseDouble(data['price']),
      imageUrl: data['imageUrl']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      offerId: data['offerId']?.toString(),
      categoryId: data['categoryId']?.toString(),
      deliveryInfo: data['deliveryInfo']?.toString() ?? '',
      termsPolicy: data['termsPolicy']?.toString() ?? '',
      isFreeDelivery: data['isFreeDelivery'] == true,
      freeDeliveryNotice:
          data['freeDeliveryNotice']?.toString() ?? '',
      deliveryFee: _parseDouble(data['deliveryFee']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'offerId': offerId,
      'categoryId': categoryId,
      'deliveryInfo': deliveryInfo ?? '',
      'termsPolicy': termsPolicy ?? '',
      'isFreeDelivery': isFreeDelivery,
      'freeDeliveryNotice': freeDeliveryNotice ?? '',
      'deliveryFee': isFreeDelivery ? 0.0 : deliveryFee,
    };
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
      'deliveryInfo': deliveryInfo ?? '',
      'termsPolicy': termsPolicy ?? '',
      'isFreeDelivery': isFreeDelivery,
      'freeDeliveryNotice': freeDeliveryNotice ?? '',
      'deliveryFee': isFreeDelivery ? 0.0 : deliveryFee,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? category,
    String? categoryId,
    String? offerId,
    String? description,
    String? deliveryInfo,
    String? termsPolicy,
    bool? isFreeDelivery,
    String? freeDeliveryNotice,
    double? deliveryFee,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      offerId: offerId ?? this.offerId,
      description: description ?? this.description,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      termsPolicy: termsPolicy ?? this.termsPolicy,
      isFreeDelivery: isFreeDelivery ?? this.isFreeDelivery,
      freeDeliveryNotice:
          freeDeliveryNotice ?? this.freeDeliveryNotice,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '0') ?? 0.0;
  }
}