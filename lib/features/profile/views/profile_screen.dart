import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/controller/navcontroller.dart';
import 'package:food_delivery/features/profile/views/faq_screen.dart';
import 'package:food_delivery/features/profile/views/help_screen.dart';
import 'package:food_delivery/features/orders/views/order_screen.dart';
import 'package:food_delivery/features/profile/controller/profile_controller.dart';
import 'package:food_delivery/features/profile/views/edit_profile_screen.dart';
import 'package:food_delivery/features/profile/views/pending_review_screen.dart';
import 'package:food_delivery/features/profile/widget/profile_header.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.background, 
      body: SafeArea(
        child: GetBuilder<ProfileController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      if (Get.isRegistered<NavController>()) {
                        Get.find<NavController>().changeTab(0);
                      } else {
                        Get.back();
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'My profile',
                    style: GoogleSansRoundedStyles.bold(
                      size: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Personal details',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Get.to(() => EditProfileScreen());
                          await controller.loadUserProfile();
                        },
                        child: Text(
                          'change',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColor.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ProfileHeader(
                      name: controller.userName,
                      email: controller.userEmail,
                      phone: controller.userPhone,
                      address: controller.userAddress,
                      profileImage: controller.userProfileImage,
                    ),
                  ),

                  const SizedBox(height: 18),
                  _buildMenuCard(
                    title: 'Orders',
                    onTap: () => Get.to(() => OrderScreen()),
                  ),
                  _buildMenuCard(
                    title: 'Pending reviews',
                    onTap: () => Get.to(() => PendingReviewsScreen()),
                  ),
                  _buildMenuCard(
                    title: 'Faq',
                    onTap: () => Get.to(() => FaqScreen()),
                  ),
                  _buildMenuCard(
                    title: 'Help',
                    onTap: () => Get.to(() => HelpScreen()),
                  ),

                  const SizedBox(height: 28),
                  SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Get.to(() => EditProfileScreen());
                        await controller.loadUserProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildMenuCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
}