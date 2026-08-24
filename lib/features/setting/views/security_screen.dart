import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/features/setting/controllers/security_controller.dart';
import 'package:food_delivery/features/setting/views/privacy_policy_screen.dart';
import 'package:food_delivery/features/setting/widgets/security_option_tile.dart';
import 'package:get/get.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  void _showChangePasswordDialog(BuildContext context, SecurityController controller) {
    controller.clearDialogErrors();
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: currentController, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
              const SizedBox(height: 10),
              TextField(controller: newController, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
              const SizedBox(height: 10),
              TextField(controller: confirmController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm New Password')),
              const SizedBox(height: 8),
              // ✅ Obx — error text ab GetX se reactive, koi setState nahi
              Obx(() => controller.passwordDialogError.value != null
                  ? Text(controller.passwordDialogError.value!, style: const TextStyle(color: Colors.red, fontSize: 12))
                  : const SizedBox.shrink()),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.changePassword(
                          currentPassword: currentController.text.trim(),
                          newPassword: newController.text.trim(),
                          confirmPassword: confirmController.text.trim(),
                        ),
                child: controller.isLoading.value
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Update', style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, SecurityController controller) {
    controller.clearDialogErrors();
    final passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This action is permanent and cannot be undone. Enter your password to confirm.', style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 8),
            Obx(() => controller.deleteDialogError.value != null
                ? Text(controller.deleteDialogError.value!, style: const TextStyle(color: Colors.red, fontSize: 12))
                : const SizedBox.shrink()),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: controller.isLoading.value ? null : () => controller.deleteAccount(currentPassword: passwordController.text.trim()),
                child: controller.isLoading.value
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Delete', style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SecurityController>() ? Get.find<SecurityController>() : Get.put(SecurityController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Security', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('ACCOUNT', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 10),
          SecurityOptionTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () => _showChangePasswordDialog(context, controller),
          ),
          Obx(() => SecurityOptionTile(
                icon: Icons.fingerprint,
                title: 'Biometric Lock',
                subtitle: 'Require fingerprint/face to open app',
                trailing: Switch(value: controller.biometricEnabled.value, activeThumbColor: AppColor.primary, onChanged: controller.toggleBiometric),
              )),
          const SizedBox(height: 20),
          Text('PRIVACY', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 10),
          SecurityOptionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read how we handle your data',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  PrivacyPolicyScreen())),
          ),
          const SizedBox(height: 20),
          Text('DANGER ZONE', style: TextStyle(fontSize: 12, color: Colors.red.shade400, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 10),
          SecurityOptionTile(
            icon: Icons.delete_forever_outlined,
            iconColor: Colors.red,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account and data',
            onTap: () => _showDeleteAccountDialog(context, controller),
          ),
        ],
      ),
    );
  }
}