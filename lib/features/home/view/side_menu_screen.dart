import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/auth/auth_screen.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/orders/views/order_screen.dart';
import 'package:food_delivery/features/offers/views/my_offerscreen.dart';
import 'package:food_delivery/features/profile/views/profile_screen.dart';
import 'package:food_delivery/features/setting/views/privacy_policy_screen.dart';
import 'package:food_delivery/features/setting/views/security_screen.dart';
import 'package:get/get.dart';

class SideMenuScreen extends StatefulWidget {
  const SideMenuScreen({super.key});

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Material(
      color: AppColor.primary,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            _menuItem(
              Icons.person_outline,
              'Profile',
              textStyle: GoogleSansRoundedStyles.medium(
                size: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              onTap: () {
                Get.to(() => ProfileScreen());
              },
            ),
            _menuItem(
              Icons.shopping_bag_outlined,
              'orders',
              textStyle: GoogleSansRoundedStyles.medium(
                size: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              onTap: () {
                Get.to(() => OrderScreen());
              },
            ),
            _menuItem(
              Icons.local_offer_outlined,
              'offer and promo',
              textStyle: GoogleSansRoundedStyles.medium(
                size: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              onTap: () {
                Get.to(() => MyOffersScreen());
              },
            ),
            _menuItem(
              Icons.privacy_tip_outlined,
              'Privacy policy',
              textStyle: GoogleSansRoundedStyles.medium(
                size: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              onTap: () {
                Get.to(() => PrivacyPolicyScreen());
              },
            ),
            _menuItem(
              Icons.shield_outlined,
              'Security',
              textStyle: GoogleSansRoundedStyles.medium(
                size: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              showDivider: false,
              onTap: () {
                Get.to(() => SecurityScreen());
              },
            ),
           Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    auth.signOut().then((value) {
                      Get.offAll(() => AuthScreen());
                      Get.snackbar(
                        "Logged Out",
                        "You have been signed out successfully.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColor.primary.withValues(alpha: 0.6),
                        colorText: Colors.white,
                        margin:  EdgeInsets.all(12),
                        borderRadius: 8,
                        duration:  Duration(seconds: 3),
                      );
                    });
                  },
                  child: Text(
                    'Sign-out',
                    style: GoogleSansRoundedStyles.medium(
                      size: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
               SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
           SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title, {
    bool showDivider = true,
    TextStyle? textStyle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white24,
      highlightColor: Colors.white10,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          textStyle ??
                          GoogleSansRoundedStyles.medium(
                            size: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
              if (showDivider) ...[
                const SizedBox(height: 14),
                Container(height: 1, color: Colors.white24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
