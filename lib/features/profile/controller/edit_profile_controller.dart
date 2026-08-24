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

  final countryCode = '+92'.obs;
  final countryFlag = '🇵🇰'.obs;

  static const String cloudName = 'awjnoxag';
  static const String uploadPreset = 'profile_images';

  String get userEmail {
    return _auth.currentUser?.email ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    nameController.text = user.displayName ?? '';

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          if (data['name'] != null && data['name'].toString().isNotEmpty) {
            nameController.text = data['name'].toString();
          }
          phoneController.text = data['phone']?.toString() ?? '';
          addressController.text = data['address']?.toString() ?? '';
          profileImageUrl = data['profileImageUrl']?.toString();
          countryCode.value = data['countryCode']?.toString() ?? '+92';
          countryFlag.value = data['countryFlag']?.toString() ?? '🇵🇰';
          if (data['paymentMethod'] != null) {
            selectedPaymentMethod.value = data['paymentMethod'];
          }
        }
        update();
      }
    } catch (e) {
      debugPrint('Profile load error: $e');
    }
  }

  void changeCountry({
    required String code,
    required String flag,
  }) {
    countryCode.value = code;
    countryFlag.value = flag;
    update();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;
    profileImageBytes = await image.readAsBytes();
    update();
  }

  Future<String?> uploadImageToCloudinary() async {
    if (profileImageBytes == null) {
      return profileImageUrl;
    }
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );
      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          profileImageBytes!,
          filename: 'profile_image.jpg',
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(responseBody);
        return data['secure_url'];
      }
      debugPrint('Cloudinary upload failed: $responseBody');
      return null;
    } catch (e) {
      debugPrint('Cloudinary upload error: $e');
      return null;
    }
  }

  void changePaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  Future<void> updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a name');
      return;
    }
    if (phone.isEmpty) {
      Get.snackbar('Error', 'Please enter a phone number');
      return;
    }
    if (countryCode.value == '+92' && phone.length != 10) {
      Get.snackbar(
        'Error',
        'Pakistan number must be 10 digits long after +92',
      );
      return;
    }
    if (address.isEmpty) {
      Get.snackbar('Error', 'Enter your address');
      return;
    }

    isLoading.value = true;
    try {
      String? imageUrl = profileImageUrl;
      if (profileImageBytes != null) {
        imageUrl = await uploadImageToCloudinary();
        if (imageUrl == null) {
          Get.snackbar('Error', 'Image upload failed. Try again.');
          isLoading.value = false;
          return;
        }
      }

      await user.updateDisplayName(name);

      await _firestore.collection('users').doc(user.uid).set(
        {
          'name': name,
          'email': user.email ?? '',
          'phone': phone,
          'countryCode': countryCode.value,
          'countryFlag': countryFlag.value,
          'address': address,
          'profileImageUrl': imageUrl,
          'paymentMethod': selectedPaymentMethod.value,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      profileImageUrl = imageUrl;
      profileImageBytes = null;
      update();

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );

      Future.delayed(const Duration(milliseconds: 1000), () {
        Get.back();
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Profile could not be updated');
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message ?? 'Data could not be saved');
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      debugPrint('Update error: $e');
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