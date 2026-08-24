import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SecurityController extends GetxController {
  final _box = GetStorage();
  final _auth = FirebaseAuth.instance;

  var biometricEnabled = false.obs;
  var isLoading = false.obs;

  // ✅ NEW — dono dialogs ke error messages ab yahan, setState ki zaroorat nahi
  var passwordDialogError = Rxn<String>();
  var deleteDialogError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    biometricEnabled.value = _box.read('biometric_enabled') ?? false;
  }

  void toggleBiometric(bool value) {
    biometricEnabled.value = value;
    _box.write('biometric_enabled', value);
  }

  void clearDialogErrors() {
    passwordDialogError.value = null;
    deleteDialogError.value = null;
  }

  Future<void> changePassword({required String currentPassword, required String newPassword, required String confirmPassword}) async {
    if (newPassword.length < 6) {
      passwordDialogError.value = 'New password must be at least 6 characters';
      return;
    }
    if (newPassword != confirmPassword) {
      passwordDialogError.value = 'Passwords do not match';
      return;
    }

    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      passwordDialogError.value = 'No logged-in user found';
      return;
    }

    try {
      isLoading.value = true;
      passwordDialogError.value = null;

      final cred = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      passwordDialogError.value = null;
      Get.back(); // ✅ success — dialog band
      Get.snackbar('Success', 'Password updated successfully', snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      passwordDialogError.value = switch (e.code) {
        'wrong-password' => 'Current password is incorrect',
        'weak-password' => 'New password is too weak',
        _ => e.message ?? 'Something went wrong',
      };
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount({required String currentPassword}) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      deleteDialogError.value = 'No logged-in user found';
      return;
    }

    try {
      isLoading.value = true;
      deleteDialogError.value = null;

      final cred = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.delete();

      Get.until((route) => route.isFirst); // ✅ success — root tak wapas
    } on FirebaseAuthException catch (e) {
      deleteDialogError.value = e.message ?? 'Unable to delete account';
    } finally {
      isLoading.value = false;
    }
  }
}