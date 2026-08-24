import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/auth/auth_screen.dart';
import 'package:get/get.dart';
import 'package:food_delivery/features/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      Get.snackbar('Error', 'Enter email and password');
      return;
    }
    if (!isLogin.value && nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Enter name');
      return;
    }

    isLoading.value = true;
    try {
      if (isLogin.value) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isOnboardingDone', true);

        Get.offAll(() => Dashboard());
      } else {
        final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        await credential.user?.updateDisplayName(nameController.text.trim());

        await _auth.signOut();
        passwordController.clear();
        isLogin.value = true;

        Get.snackbar('Success', 'Account created successfully');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Enter email');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Something went wrong');
    }
  }
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => AuthScreen());
  }
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}