import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class OrderController extends ChangeNotifier {
  // Current user ke orders ka Stream fetch karne ke liye
  Stream<QuerySnapshot> getUserOrders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
    return const Stream.empty();
  }
}