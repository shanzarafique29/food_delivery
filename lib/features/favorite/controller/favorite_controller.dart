import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:food_delivery/models/productmodel.dart';

class FavoriteController extends GetxController {
  final RxList<ProductModel> favorites = <ProductModel>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _favoritesCollection {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites');
  }

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // =========================
  // CHECK FAVORITE
  // =========================
  bool isFavorite(ProductModel product) {
    return favorites.any((item) => item.id == product.id);
  }

  // =========================
  // ADD / REMOVE FAVORITE
  // =========================
  Future<void> toggleFavorite(ProductModel product) async {
    final user = _auth.currentUser;

    if (user == null) {
      Get.snackbar(
        'Login required',
        'Please login to add favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final productId = product.id ?? product.name;

    final index = favorites.indexWhere(
      (item) => (item.id ?? item.name) == productId,
    );

    try {
      if (index >= 0) {
        // REMOVE FROM FIRESTORE
        await _favoritesCollection.doc(productId).delete();

        favorites.removeAt(index);
      } else {
        // ADD TO FIRESTORE
        await _favoritesCollection.doc(productId).set({
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'category': product.category,
          'description': product.description,
          'createdAt': FieldValue.serverTimestamp(),
        });

        favorites.add(product);
      }

      favorites.refresh();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to update favorite',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =========================
  // LOAD FAVORITES
  // =========================
  Future<void> loadFavorites() async {
    final user = _auth.currentUser;

    if (user == null) {
      favorites.clear();
      return;
    }

    try {
      final snapshot = await _favoritesCollection.get();

      final loadedFavorites = snapshot.docs.map((doc) {
        final data = doc.data();

        return ProductModel(
          id: data['productId']?.toString() ?? doc.id,
          name: data['name']?.toString() ?? '',
          price: _parsePrice(data['price']),
          imageUrl: data['imageUrl']?.toString() ?? '',
          category: data['category']?.toString() ?? '',
          description: data['description']?.toString() ?? '',
        );
      }).toList();

      favorites.assignAll(loadedFavorites);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =========================
  // SAFE PRICE CONVERTER
  // =========================
  double _parsePrice(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }
}