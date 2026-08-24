import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = '';
  String userEmail = '';
  String userPhone = 'Phone number not added';
  String userAddress = 'Address not added';
  String userProfileImage = '';

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) return;

    // Default values from FirebaseAuth instance
    userName = user.displayName ?? '';
    userEmail = user.email ?? '';
    userPhone = (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
        ? user.phoneNumber!
        : 'Phone number not added';

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();

        if (data != null) {
          userName = data['name']?.toString() ?? userName;
          userEmail = data['email']?.toString() ?? userEmail;

          if (data['phone'] != null && data['phone'].toString().trim().isNotEmpty) {
            userPhone = data['phone'].toString();
          }

          if (data['address'] != null && data['address'].toString().trim().isNotEmpty) {
            userAddress = data['address'].toString();
          } else {
            userAddress = 'Address not added';
          }

          userProfileImage = data['profileImageUrl']?.toString() ?? '';
        }
      }

      // Rebuild GetBuilder widgets in ProfileScreen
      update();
    } catch (e) {
      print('Profile load error: $e');
    }
  }
}