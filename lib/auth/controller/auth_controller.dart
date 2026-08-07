import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_delivery/features/dashboard.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLogin = true.obs;
  var isLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void switchToLogin() => isLogin.value = true;

  void switchToSignup() => isLogin.value = false;

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email aur password dalna zaroori hai');
      return;
    }
    if (!isLogin.value && nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Naam dalna zaroori hai');
      return;
    }

    isLoading.value = true;
    try {
      if (isLogin.value) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.offAll(() =>  Dashboard());
      } else {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await credential.user?.updateDisplayName(nameController.text.trim());
        await _auth.signOut();

        passwordController.clear();
        isLogin.value = true;

        Get.snackbar('Success', 'Account ban gaya, ab login karen');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Kuch ghalat ho gaya');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Pehle email dalen');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset link email par bhej di gayi hai');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Kuch ghalat ho gaya');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}