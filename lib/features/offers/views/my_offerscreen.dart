import 'package:flutter/material.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:get/get.dart';

class MyOffersScreen extends StatelessWidget {
  const MyOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyOffersController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "My Offers",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.offersList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ohh snap! No offers yet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  "Bella doesn’t have any offers yet, please check again.",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.offersList.length,
          itemBuilder: (context, index) {
            final offer = controller.offersList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((offer.imageUrl ?? '').isNotEmpty)
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        offer.imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(height: 150, color: Colors.grey.shade200),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(offer.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          "Code: ${offer.code} | Discount: ${offer.discountPercent}%",
                          style: const TextStyle(color: Colors.orange),
                        ),
                        const SizedBox(height: 4),
                        if ((offer.description ?? '').isNotEmpty)
                          Text(offer.description!,
                              style: const TextStyle(color: Colors.grey)),
                        if ((offer.termsAndConditions ?? '').isNotEmpty)
                          Text("Terms: ${offer.termsAndConditions!}",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 6),
                        if (offer.expiryDate != null)
                          Text(
                            "Expires on: ${offer.expiryDate!.toLocal().toString().split(' ')[0]}",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        if (offer.isFeatured)
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("Featured Offer",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
