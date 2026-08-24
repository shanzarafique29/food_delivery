import 'package:flutter/material.dart';
import 'package:food_delivery/auth/controller/auth_controller.dart';
import 'package:food_delivery/auth/forgetpassword_screen.dart';
import 'package:food_delivery/auth/widgets/customtextfield.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final AuthController controller = Get.put(AuthController());

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
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                     SizedBox(height: 50),
                    Image.asset('assets/images/app logo.png', height: size.height * 0.15),
                     SizedBox(height: 24),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTab('Login', controller.isLogin.value, controller.switchToLogin),
                            SizedBox(width: size.width * 0.2),
                            _buildTab('Sign-up', !controller.isLogin.value, controller.switchToSignup),
                          ],
                        )),
                     SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!controller.isLogin.value) ...[
                          CustomTextField(label: 'Full name', controller: controller.nameController, keyboardType: TextInputType.name),
                          const SizedBox(height: 22),
                        ],
                        CustomTextField(label: 'Email address', controller: controller.emailController, keyboardType: TextInputType.emailAddress),
                        SizedBox(height: 22),
                        CustomTextField(
                          label: 'Password',
                          focusColor: AppColor.primary,
                          keyboardType: TextInputType.visiblePassword,
                          controller: controller.passwordController,
                          obscureText: true,
                        ),
                        if (controller.isLogin.value) ...[
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: () => Get.to(() => ForgotPasswordScreen()), 
                            child: Text(
                              'Forgot passcode?',
                              style: GoogleSansRoundedStyles.bold(size: 15, color: AppColor.primary, fontWeight: FontWeight.bold, height: 1.0),
                            ),
                          ),
                        ],
                         SizedBox(height: 40),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: SizedBox(
                            width: size.width,
                            height: size.height * 0.07,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value ? null : controller.submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      controller.isLogin.value ? 'Login' : 'Sign-up',
                                      style: GoogleSansRoundedStyles.bold(size: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: active ? Colors.black : Colors.grey)),
          const SizedBox(height: 6),
          Container(height: 2, width: 100, color: active ? AppColor.primary : Colors.transparent),
        ],
      ),
    );
  }
}
