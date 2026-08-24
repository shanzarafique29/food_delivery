import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:food_delivery/features/offers/views/my_offerscreen.dart';

import 'package:get/get.dart';

class ActiveOffersBanner extends StatelessWidget {
  const ActiveOffersBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MyOffersController>()
        ? Get.find<MyOffersController>()
        : Get.put(MyOffersController());
       final size = MediaQuery.of(context).size;
    return Obx(() {
      if (controller.offersList.isEmpty) return  SizedBox.shrink();

      final count = controller.offersList.length;
      final firstOffer = controller.offersList.first;

      return GestureDetector(
        onTap: () => Get.to(() =>  MyOffersScreen()),
        child: Container(
          margin:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.primary, AppColor.primary.withValues(alpha: 0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
               Icon(Icons.local_offer_rounded, color: Colors.white, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count == 1
                          ? firstOffer.title
                          : '$count offers available right now',
                      style: GoogleSansRoundedStyles.thin(size: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                     SizedBox(height: 2),
                    Text(
                      count == 1
                          ? 'Tap to see details'
                          : 'Tap to see all offers',
                      style:  GoogleSansRoundedStyles.thin(size: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
               Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      );
    });
  }
}