import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutController extends ChangeNotifier {
  String selectedDeliveryMethod = 'Door delivery';
  String selectedPaymentMethod = 'Card';
  bool isSaving = false;

  void setDeliveryMethod(String method) {
    selectedDeliveryMethod = method;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<void> placeOrderWithDetails({
    required BuildContext context,
    required List<Map<String, dynamic>> cartItems,
    required double totalPrice,
    required String deliveryMethod,
    required String deliveryAddress,
  }) async {
    isSaving = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('orders').add({
          'userId': user.uid,
          'items': cartItems,
          'totalPrice': totalPrice,
          'deliveryType': deliveryMethod,
          'deliveryAddress': deliveryAddress,
          'paymentMethod': selectedPaymentMethod,
          'status': 'Processing',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed successfully!')),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}