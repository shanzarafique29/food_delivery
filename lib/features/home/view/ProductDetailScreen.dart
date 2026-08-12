import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:food_delivery/features/orders/order_screen.dart';
import 'package:food_delivery/models/productmodel.dart';
import 'package:food_delivery/models/offermodel.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final offersController = Get.find<MyOffersController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        // ✅ 1. Active Offer Lookup (Real-time sync)
        final now = DateTime.now();
        OfferModel? linkedOffer = offersController.offersList.firstWhereOrNull((o) {
          if (!o.isActive) return false;
          if (o.expiryDate != null && o.expiryDate!.isBefore(now)) return false;

          bool matchesProductId = o.productId != null && o.productId == product.id;
          bool matchesCategoryId = o.categoryId != null && o.categoryId == product.categoryId;
          bool matchesDirectOfferId = product.offerId != null && o.id == product.offerId;

          return matchesProductId || matchesCategoryId || matchesDirectOfferId;
        });

        // ✅ 2. Dynamic Discounted Price Calculation
        double originalPrice = product.price;
        double finalPrice = originalPrice;
        if (linkedOffer != null) {
          finalPrice = originalPrice * (1 - (linkedOffer.discountPercent / 100));
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular Product Image Container
                      Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 25,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: Colors.white, child: const Icon(Icons.fastfood, size: 80, color: Colors.grey)),
                                )
                              : Container(color: Colors.white, child: const Icon(Icons.fastfood, size: 80, color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Product Name
                      Text(
                        product.name,
                        textAlign: TextAlign.center,
                        style: GoogleSansRoundedStyles.bold(
                          size: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dynamic Price Rendering (Original vs Discounted)
                      if (linkedOffer != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "N${originalPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "N${finalPrice.toStringAsFixed(0)}",
                              style: GoogleSansRoundedStyles.bold(
                                size: 22,
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          "N${originalPrice.toStringAsFixed(0)}",
                          style: GoogleSansRoundedStyles.bold(
                            size: 22,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Linked Offer Details Box
                      if (linkedOffer != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColor.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColor.primary.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_offer, color: AppColor.primary, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    linkedOffer.title,
                                    style: GoogleSansRoundedStyles.bold(
                                      size: 15,
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${linkedOffer.discountPercent.toInt()}% OFF applied on this product!",
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                              if (linkedOffer.expiryDate != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Valid till: ${linkedOffer.expiryDate!.toLocal().toString().split(' ').first}",
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Description Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Delivery info",
                          style: GoogleSansRoundedStyles.bold(size: 16, color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.description.isNotEmpty 
                              ? product.description 
                              : "Delivered between Monday and Sunday from 8pm to 11:32pm.",
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Button Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => OrderScreen(product: product, offer: linkedOffer));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}