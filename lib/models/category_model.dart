// import 'package:cloud_firestore/cloud_firestore.dart';

// class CategoryModel {
//   final String? id;
//   final String name;

//   CategoryModel({
//     this.id,
//     required this.name,
//   });

//   factory CategoryModel.fromSnapshot(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return CategoryModel(
//       id: doc.id,
//       name: data['name'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String? id;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final DateTime? createdAt;

  CategoryModel({
    this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.isActive = true,
    this.createdAt,
  });

  factory CategoryModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
