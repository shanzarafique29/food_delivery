import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/features/home/view/homescreen.dart';
import 'package:get/get.dart';

import 'package:food_delivery/features/Cart/controller/cart_controller.dart';

class CheckoutController extends ChangeNotifier {
  String selectedDeliveryMethod = 'Door delivery';
  String selectedPaymentMethod = 'Card';

  bool isSaving = false;

  // ============================================================
  // DELIVERY METHOD
  // ============================================================

  void setDeliveryMethod(String method) {
    selectedDeliveryMethod = method;
    notifyListeners();
  }

  // ============================================================
  // PAYMENT METHOD
  // ============================================================

  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<void> placeOrderWithDetails({
    required BuildContext context,
    required List<Map<String, dynamic>> cartItems,
    required double totalPrice,
    required String deliveryMethod,
    required String deliveryAddress,
  }) async {
    if (isSaving) return;

    isSaving = true;
    notifyListeners();

    try {
      // --------------------------------------------------------
      // 1. CHECK LOGIN
      // --------------------------------------------------------

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please login before placing an order',
              ),
            ),
          );
        }

        return;
      }

      // --------------------------------------------------------
      // 2. SAVE ORDER TO FIRESTORE
      // --------------------------------------------------------

      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,

        // Cart products
        'items': cartItems,

        // Final amount including delivery charge
        'totalPrice': totalPrice,

        // Delivery information
        'deliveryType': deliveryMethod,
        'deliveryAddress': deliveryAddress,

        // Payment information
        'paymentMethod': selectedPaymentMethod,

        // Order status
        'status': 'Processing',

        // Time
        'createdAt': FieldValue.serverTimestamp(),
      });

      // --------------------------------------------------------
      // 3. CLEAR FIRESTORE CART
      // --------------------------------------------------------

      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      for (final doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      // --------------------------------------------------------
      // 4. CLEAR APP MEMORY CART
      // --------------------------------------------------------

      if (Get.isRegistered<CartController>()) {
        final cartController = Get.find<CartController>();

        cartController.clearCart();
      }

      // --------------------------------------------------------
      // 5. SUCCESS MESSAGE
      // --------------------------------------------------------

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Order placed successfully!',
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // ------------------------------------------------------
        // 6. GO BACK TO HOME
        // ------------------------------------------------------
        Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => const HomeScreen(),
  ),
  (route) => false,
);
      }
    } catch (e) {
      // --------------------------------------------------------
      // ERROR
      // --------------------------------------------------------

      debugPrint('Place order error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to place order: $e',
            ),
          ),
        );
      }
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}