import 'package:flutter/material.dart';
import 'package:food_delivery/auth/controller/forgetpassword_controller.dart';
import 'package:food_delivery/auth/widgets/customtextfield.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    IconButton(
                      alignment: Alignment.centerLeft,
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                    Image.asset('assets/images/app logo.png', height: size.height * 0.12),
                    const SizedBox(height: 20),
                    Text(
                      'Forgot Password?',
                      style: GoogleSansRoundedStyles.bold(size: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your email address and we\'ll send you a link to reset your password.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Email address',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 40), 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        width: size.width,
                        height: size.height * 0.07,
                        child: Obx(() => ElevatedButton(
                              onPressed: controller.isLoading.value ? null : controller.sendResetLink,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Send Reset Link',
                                      style: GoogleSansRoundedStyles.bold(size: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                            )),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}