import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  final String name;
  final double price;          
  final String imageUrl;
  final String category;
  final String description;
  final Timestamp? createdAt;  

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    this.createdAt,
  });

  factory ProductModel.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>? ?? {};
    return ProductModel(
      id: snap.id,
      name: data['name']?.toString() ?? '',
      price: _parsePrice(data['price']),
      imageUrl: data['imageUrl']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      createdAt: _parseTimestamp(data['createdAt']),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return ProductModel(
      id: docId ?? json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      price: _parsePrice(json['price']),
      imageUrl: json['imageUrl']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: _parseTimestamp(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Safe Helper Methods to Prevent Type Casting Crashes
  static double _parsePrice(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  static Timestamp? _parseTimestamp(dynamic val) {
    if (val == null) return null;
    if (val is Timestamp) return val;
    if (val is int) return Timestamp.fromMillisecondsSinceEpoch(val);
    if (val is String) {
      DateTime? dt = DateTime.tryParse(val);
      if (dt != null) return Timestamp.fromDate(dt);
    }
    return null;
  }
}