import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var favoriteList = <ProductModel>[].obs;
  var isLoading = true.obs;

  StreamSubscription? _favoritesSub; 

  @override
  void onInit() {
    super.onInit();
    _listenToFavorites();
  }

  String? get currentUserId => _auth.currentUser?.uid;

  void _listenToFavorites() {
    if (currentUserId == null) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    _favoritesSub = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('favorites')
        .snapshots()
        .listen(
      (snapshot) {
        favoriteList.value =
            snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        Get.snackbar("Error", "Failed to load favorites");
      },
    );
  }

  bool isFavorite(ProductModel product) {
    return favoriteList.any((item) => item.id == product.id);
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (currentUserId == null) return;

    final isFav = isFavorite(product);
    final favRef = _firestore.collection('users').doc(currentUserId).collection('favorites').doc(product.id);

    try {
      if (isFav) {
        await favRef.delete();
      } else {
        await favRef.set(product.toMap());
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to update favorites");
    }
  }

  Future<void> clearAllFavorites() async {
    if (currentUserId == null) return;
    try {
      final batch = _firestore.batch();
      final collection = _firestore.collection('users').doc(currentUserId).collection('favorites');

      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      Get.snackbar("Error", "Failed to clear favorites");
    }
  }

  @override
  void onClose() {
    _favoritesSub?.cancel(); 
    super.onClose();
  }
}