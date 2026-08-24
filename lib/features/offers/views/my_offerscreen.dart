import 'package:flutter/material.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:food_delivery/features/offers/widgets/offer_card.dart';
import 'package:get/get.dart';

class MyOffersScreen extends StatelessWidget {
  const MyOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MyOffersController>()
        ? Get.find<MyOffersController>()
        : Get.put(MyOffersController());
      final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:  Color(0xFFF6F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title:  Text('My Offers', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingPromos.value) {
          return  Center(child: CircularProgressIndicator());
        }

        if (controller.promoError.value != null) {
          return Center(
            child: Padding(
              padding:  EdgeInsets.all(24),
              child: Text(
                'Unable to load offers:\n${controller.promoError.value}',
                textAlign: TextAlign.center,
                style:  TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (controller.promoCodesList.isEmpty) {
          return Center(
            child: Text('No offers available right now', style: TextStyle(color: Colors.grey)),
          );
        }

        return ListView.builder(
          padding:  EdgeInsets.all(20),
          itemCount: controller.promoCodesList.length,
          itemBuilder: (context, index) => OfferCard(offer: controller.promoCodesList[index]),
        );
      }),
    );
  }
}