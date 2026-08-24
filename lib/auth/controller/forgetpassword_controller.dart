import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  var isLoading = false.obs;
  var isSent = false.obs;

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Enter your email');
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      isSent.value = true;
      Get.snackbar('Success', 'Password reset link sent to $email');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}