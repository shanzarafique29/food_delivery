import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/features/controller/navcontroller.dart';
import 'package:food_delivery/features/orders/order_screen.dart';
import 'package:food_delivery/features/profile/controller/profile_controller.dart';
import 'package:food_delivery/features/profile/edit_profile/edit_profile_screen.dart';
import 'package:food_delivery/features/profile/widget/profile_header.dart';
import 'package:food_delivery/features/profile/widget/profile_menu_item.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: GetBuilder<ProfileController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(21, 25, 21, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final navController = Get.find<NavController>();

                          navController.changeTab(0);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'My profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Personal details',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
                                fontSize: 12,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      ProfileHeader(
                        name: controller.userName,
                        email: controller.userEmail,
                        phone: controller.userPhone,
                        address: controller.userAddress,
                        profileImage: controller.userProfileImage,
                      ),

                      const SizedBox(height: 14),

                      ProfileMenuItem(
                        title: 'Orders',
                        onTap: () {
                          Get.to(() => OrderScreen());
                        },
                      ),

                      ProfileMenuItem(title: 'Pending reviews', onTap: () {}),

                      ProfileMenuItem(title: 'Faq', onTap: () {}),

                      ProfileMenuItem(title: 'Help', onTap: () {}),

                      const SizedBox(height: 17),

                      SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Get.to(() => EditProfileScreen());
                            await controller.loadUserProfile();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
