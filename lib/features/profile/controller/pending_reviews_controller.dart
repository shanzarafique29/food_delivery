import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PendingReviewsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<Map<String, dynamic>> pendingReviews =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingReviews();
  }

  Future<void> fetchPendingReviews() async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;

      if (user == null) {
        pendingReviews.clear();
        return;
      }

      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .get();
      final List<Map<String, dynamic>> reviews = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status']?.toString().toLowerCase();
        if (status != 'completed' && status != 'delivered') {
          continue;
        }

        final items = data['items'];

        if (items is List) {
          for (final item in items) {
            if (item is Map<String, dynamic>) {
              final reviewed = item['reviewed'] == true;
              if (!reviewed) {
                reviews.add({
                  'orderId': doc.id,
                  'productId': item['productId']?.toString() ?? '',
                  'name': item['name']?.toString() ?? 'Product',
                  'imageUrl': item['imageUrl']?.toString() ?? '',
                  'price': item['price'] ?? 0,
                });
              }
            }
          }
        }
      }

      pendingReviews.assignAll(reviews);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load pending reviews',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitReview({
    required Map<String, dynamic> product,
    required int rating,
    required String comment,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _firestore.collection('reviews').add({
        'userId': user.uid,
        'productId': product['productId'],
        'productName': product['name'],
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });

      pendingReviews.remove(product);

      Get.snackbar(
        'Thank you!',
        'Your review has been submitted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to submit review',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}