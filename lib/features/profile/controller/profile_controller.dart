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

    // Google account ka initial data
    userName = user.displayName ?? '';
    userEmail = user.email ?? '';
    userPhone = user.phoneNumber ?? 'Phone number not added';

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

          userPhone = (data['phone'] != null &&
                  data['phone'].toString().isNotEmpty)
              ? data['phone'].toString()
              : userPhone;

          userAddress = (data['address'] != null &&
                  data['address'].toString().isNotEmpty)
              ? data['address'].toString()
              : 'Address not added';

          userProfileImage =
              data['profileImageUrl']?.toString() ?? '';
        }
      }

      update();
    } catch (e) {
      print('Profile load error: $e');
    }
  }
}