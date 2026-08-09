
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Uint8List? profileImageBytes;
  String? profileImageUrl;

  final selectedPaymentMethod = 0.obs;
  final isLoading = false.obs;

  // Country code
  final countryCode = '+92'.obs;
  final countryFlag = '🇵🇰'.obs;

  // Cloudinary settings
  static const String cloudName = 'awjnoxag';
  static const String uploadPreset = 'profile_images';

  String get userEmail {
    return _auth.currentUser?.email ?? '';
  }

  @override
  void onInit() {
    super.onInit();

    final user = _auth.currentUser;

    if (user != null) {
      nameController.text = user.displayName ?? '';
      phoneController.text = '';

      loadProfileData();
    }
  }

  // ================= LOAD PROFILE =================

  Future<void> loadProfileData() async {
    final user = _auth.currentUser;

    if (user == null) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();

        phoneController.text =
            data?['phone']?.toString() ?? '';

        addressController.text =
            data?['address']?.toString() ?? '';

        profileImageUrl =
            data?['profileImageUrl']?.toString();

        countryCode.value =
            data?['countryCode']?.toString() ?? '+92';

        countryFlag.value =
            data?['countryFlag']?.toString() ?? '🇵🇰';

        if (data?['paymentMethod'] != null) {
          selectedPaymentMethod.value =
              data!['paymentMethod'];
        }

        update();
      }
    } catch (e) {
      debugPrint('Profile load error: $e');
    }
  }

  // ================= COUNTRY =================

  void changeCountry({
    required String code,
    required String flag,
  }) {
    countryCode.value = code;
    countryFlag.value = flag;
    update();
  }

  // ================= PICK IMAGE =================

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    profileImageBytes = await image.readAsBytes();

    update();
  }

  // ================= CLOUDINARY =================

  Future<String?> uploadImageToCloudinary() async {
    if (profileImageBytes == null) {
      return profileImageUrl;
    }

    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest(
        'POST',
        url,
      );

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          profileImageBytes!,
          filename: 'profile_image.jpg',
        ),
      );

      final response = await request.send();

      final responseBody =
          await response.stream.bytesToString();

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final data = jsonDecode(responseBody);

        return data['secure_url'];
      }

      debugPrint(
        'Cloudinary upload failed: $responseBody',
      );

      return null;
    } catch (e) {
      debugPrint(
        'Cloudinary upload error: $e',
      );

      return null;
    }
  }

  // ================= PAYMENT =================

  void changePaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  // ================= UPDATE PROFILE =================

  Future<void> updateProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      Get.snackbar(
        'Error',
        'User login nahi hai',
      );
      return;
    }

    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name enter karein',
      );
      return;
    }

    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar(
        'Error',
        'Phone number enter karein',
      );
      return;
    }

    // Pakistan ke liye +92 ke baad 10 digits
    if (countryCode.value == '+92' &&
        phone.length != 10) {
      Get.snackbar(
        'Error',
        'Pakistan number +92 ke baad 10 digits ka hona chahiye',
      );
      return;
    }

    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Address enter karein',
      );
      return;
    }

    isLoading.value = true;

    try {
      String? imageUrl = profileImageUrl;

      // Upload new image
      if (profileImageBytes != null) {
        imageUrl = await uploadImageToCloudinary();

        if (imageUrl == null) {
          Get.snackbar(
            'Error',
            'Profile picture upload nahi ho saki',
          );
          return;
        }
      }

      // Update Firebase Auth name
      await user.updateDisplayName(
        nameController.text.trim(),
      );

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'name': nameController.text.trim(),
          'email': user.email ?? '',
          'phone': phone,
          'countryCode': countryCode.value,
          'countryFlag': countryFlag.value,
          'address': addressController.text.trim(),
          'profileImageUrl': imageUrl,
          'paymentMethod':
              selectedPaymentMethod.value,
          'updatedAt':
              FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
        profileImageUrl = imageUrl;

      // 1. Pehle Snackbar show karein
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: const EdgeInsets.all(0),
      );

      // 2. Thora sa wait kar ke phir wapas bhejein taake snackbar nazar aa sakay
      Future.delayed(const Duration(milliseconds: 1000), () {
        Get.back();
      }); 
      
     

     
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Profile update nahi ho saka',
      );
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Data save nahi ho saka',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Kuch ghalat ho gaya',
      );

      debugPrint(
        'Update error: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.onClose();
  }
}

