import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class OrderController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const List<String> activeStatuses = [
    'Pending',
    'Preparing',
    'On The Way',
  ];
  static const List<String> historyStatuses = ['Delivered', 'Cancelled'];

  final List<String> cancellationReasons = [
    'Changed my mind',
    'Ordered by mistake',
    'Delivery taking too long',
    'Found a better price elsewhere',
    'Other',
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserOrders({
    required List<String> statuses,
  }) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .where('status', whereIn: statuses)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  Future<void> requestCancellation({
    required String orderId,
    required String reason,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'cancelRequested': true,
      'cancelReason': reason,
      'cancelRequestStatus': 'pending',
      'cancelRequestedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> clearHistory() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .where('status', whereIn: historyStatuses)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'hiddenByUser': true});
    }
    await batch.commit();
  }
Future<void> hideOrder(String orderId) async {
  await _firestore.collection('orders').doc(orderId).update({'hiddenByUser': true});
}
}
